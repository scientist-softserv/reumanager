class Application < ApplicationRecord
  has_one :user
  has_one :application_search_record, dependent: :destroy

  after_initialize do
    self.data = {} if self.data.blank?
    self.recommender_info = {} if self.recommender_info.blank?
    self.state = 'started' if self.state.blank?
  end

  has_many :recommendations, dependent: :destroy do
    def valid_count
      self.map { |s| s.data_valid? ? 1 : 0 }.sum(0)
    end
  end

  enum state: {
    'started' => 'started',
    'submitted' => 'submitted',
    'completed' => 'completed',
    'accepted' => 'accepted',
    'rejected' => 'rejected',
    'withdrawn' => 'withdrawn'
  }

  validate :run_data_validations
  validate :run_recommender_info_validations

  before_save do
    # revert status if user edits information where it is invalid
    if
      (self.submitted? || self.completed?) && !self.application_valid?
      self.submitted_at = nil
      self.state = 'started'
    end
  end

  after_save do
    if self.can_complete?
      self.complete
      self.save
    end
  end

  after_commit :update_application_search_record

  scope :search, lambda { |query|
    where(
      id: ApplicationSearchRecord.where("(first_name || ' ' || last_name) ILIKE :q OR email ILIKE :q", q: "%#{query}%").select(:application_id)
    )
  }

  def update_application_search_record
    return if data.blank?

    record = self.application_search_record
    record ||= self.build_application_search_record
    record.first_name = first_name
    record.last_name = last_name
    record.email = email
    record.save
  end

  def first_name
    self.data.dig('profile', 'first_name')
  end

  def last_name
    self.data.dig('profile', 'last_name')
  end

  def email
    self.data.dig('profile', 'contact_email').presence || user.email
  end

  def update_data(new_data)
    keys = new_data.keys - self.current_application_form.sections.map(&:title_key)
    keys.each { |key| new_data.delete(key) } if keys.any?
    self.data = new_data
  end

  def update_recommendation
    return if self.recommender_info['recommenders_form'].blank?
    emails = self.recommender_info['recommenders_form'].map { |r| r['email'] }.compact
    recommendations = self.recommendations.to_a
    current_emails = recommendations.map(&:email)
    missing_emails = emails.difference(current_emails)
    missing_emails.each do |email|
      Recommendation.create!(email: email, application: self)
    end
    recommendations.each do |recommendation|
      recommendation.destroy! unless emails.include?(recommendation.email)
    end
  end

  def run_data_validations
    return unless self.changed.include?('data')
    validate_data
  end

  def run_recommender_info_validations
    return unless self.changed.include?('recommender_info')
    validate_recommenders
  end

  def data_valid?
    return @data_valid unless @data_valid.nil?
    self.errors.clear
    validate_data
    @data_valid = self.errors.empty?
  end

  def recommenders_valid?
    return @recommenders_valid unless @recommenders_valid.nil?
    self.errors.clear
    validate_recommenders
    @recommenders_valid = self.errors.empty?
  end

  def application_valid?
    data_valid? && recommenders_valid?
  end

  def validate_data
    return unless self.current_application_form
    if data.blank? || data.empty?
      self.errors.add(:base, 'Fill out application information')
      return
    end
    self.current_application_form
        .validate_data(data)
        .each { |msg| errors.add(:base, msg) }
  end

  def validate_recommenders
    return unless self.current_recommender_form
    form_data = recommender_info.fetch('recommenders_form', [])
    if form_data.blank? || form_data.empty?
      self.errors.add(:base, "Fill out recommender's information")
      return
    end
    self.current_recommender_form
        .recommender_section
        .validate_data(form_data)
        .each { |msg| errors.add(:base, msg) }
  end

  def current_application_form
    @current_application_form ||= ApplicationForm.includes(sections: :fields).where(status: :active).first
  end

  def current_recommender_form
    @current_recommender_form ||= RecommenderForm.includes(sections: :fields).where(status: :active).first
  end

  def complete
    self.completed!
    self.completed_at = Time.current
  end

  def can_complete?
    self.submitted? &&
      self.application_valid? &&
      self.recommendations.valid_count >= count_of_recommenders
  end

  def submit
    self.submitted_at = Time.current
    self.state = :submitted
  end

  def can_submit?
    self.started? &&
      self.data_valid? &&
      self.recommenders_valid? &&
      current_recommender_form.recommenders_count <= count_of_recommenders
  end

  def withdraw
    self.state = :withdrawn
  end

  def can_withdraw?
    self.started? || self.submitted? || self.completed?
  end

  def restart
    self.state = :started
  end

  def can_restart?
    self.withdrawn?
  end

  def count_of_recommenders
    recommender_info.fetch('recommenders_form', []).count
  end

  def data_flattened
    data.each_with_object({}) do |(title, section), hash|
      if section.is_a?(Hash)
        hash.merge!(section.each_with_object({}) { |(k, v), h| h[k] = { value: v, path: "#{title}--#{k}" } })
      elsif section.is_a?(Array)
        section.each_with_index do |sub_section, index|
          hash.merge!(sub_section.each_with_object({}) do |(k, v), h|
            h["#{k}_#{index + 1}"] = { value: v, path: "#{title}--#{index}--#{k}" }
          end)
        end
      end
    end
  end

  def full_name
    "#{self.data.dig('profile', 'first_name')} #{self.data.dig('profile', 'last_name')}"
  end

  def field_value(*args)
    self.data.dig(*args)
  end

  def recommender(email)
    self.recommenders.detect { |r| r.email == email }
  end

  def recommenders
    self.recommender_info['recommenders_form'].map do |hash|
      OpenStruct.new(hash.transform_keys { |k| k.downcase.tr(' ', '_') })
    end
  end
end
