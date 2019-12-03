class Application < ApplicationRecord
  has_one :user

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
    if (self.submitted? || self.completed?) && !self.application_valid?
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

  def add_errors(type, details, value, append_msg = '')
    message = append_msg.present? ? "#{append_msg} #{details[:message]}" : details[:message]
    errors.add(:base, message) if type.to_s == 'required' && [nil, ''].include?(value)
    return if value.nil?
    errors.add(:base, message) if type.to_s == 'max_length' && value.size > details[:max]
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
    validations = self.current_application_form.validations
    if data.blank? || data.empty?
      self.errors.add(:base, 'Fill out application information')
      return
    end
    validations.each do |section_key, validation|
      validation.each do |key, field_validations|
        field_validations.each do |type, details|
          if data[section_key].is_a?(Array)
            data[section_key].each_with_index do |section_data, index|
              self.add_errors(type, details, section_data[key], "#{section_key} #{index + 1}:")
            end
          else
            self.add_errors(type, details, data.dig(section_key, key))
          end
        end
      end
    end
  end

  def validate_recommenders
    return unless self.current_recommender_form
    validations = current_recommender_form.validations['recommenders_form']
    form_data = recommender_info.fetch('recommenders_form', [])
    if form_data.blank? || form_data.empty?
      self.errors.add(:base, "Fill out recommender's information")
      return
    end
    form_data.each do |form|
      validations.each do |key, validation|
        validation.each do |type, details|
          self.add_errors(type, details, form[key])
        end
      end
    end
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
