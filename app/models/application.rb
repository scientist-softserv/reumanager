class Application < ApplicationRecord
  has_one :user

  after_initialize do
    self.data = {} if self.data.blank?
    self.recommender_info = {} if self.recommender_info.blank?
  end

  has_many :recommender_statuses, dependent: :destroy do
    def valid_count
      self.map { |s| s.data_valid? ? 1 : 0 }.sum(0)
    end
  end

  enum state: {
    'started' => 'started',
    'submitted' => 'submitted',
    'completed' => 'completed',
    'withdrawn' => 'withdrawn',
    'accepted' => 'accepted',
    'rejected' => 'rejected'
  }

  validate :run_data_validations
  validate :run_recommender_info_validations

  before_save do
    self.application_valid = data_valid && recommender_info_valid
    # revert status if user edits information where it is invalid
    unless self.application_valid
      self.submitted_at = nil
      self.started!
    end
  end

  after_save do
    if self.can_complete?
      self.complete
      self.save
    end
  end

  def update_recommender_status
    return if self.recommender_info['recommenders_form'].blank?
    emails = self.recommender_info['recommenders_form'].map { |r| r['email'] }.compact
    statuses = self.recommender_statuses.to_a
    current_emails = statuses.map(&:email)
    missing_emails = emails.difference(current_emails)
    missing_emails.each do |email|
      RecommenderStatus.create!(email: email, application: self)
    end
    statuses.each do |status|
      status.destroy! unless emails.include?(status.email)
    end
  end

  def run_data_validations
    return unless self.changed.include?('data')
    return unless self.current_application_form
    validations = self.current_application_form.validations
    data_is_valid = true
    validations.each do |section_key, validation|
      validation.each do |key, field_validations|
        field_validations.each do |type, details|
          if type.to_s == 'required' && [nil, ''].include?(data.dig(section_key, key))
            data_is_valid = false
            errors.add(:base, details.messages)
          end
          if type.to_s == 'max_length' && data.dig(section_key, key).size > details.max
            data_is_valid = false
            errors.add(:base, details.messages)
          end
        end
      end
    end
    self.data_valid = data_is_valid
  end

  def run_recommender_info_validations
    return unless self.changed.include?('recommender_info')
    return unless self.current_recommender_form
    validations = current_recommender_form.validations['recommenders_form']
    info_is_valid = true
    form_data = recommender_info.fetch('recommenders_form', [])
    info_is_valid = false if form_data.empty?
    form_data.each do |form|
      validations.each do |type, details|
        if type.to_s == 'required' && [nil, ''].include?(form[key])
          info_is_valid = false
          errors.add(:base, details.messages)
        end
        if type.to_s == 'max_length' && form[key].size > details.max
          info_is_valid = false
          errors.add(:base, details.messages)
        end
      end
    end
    self.recommender_info_valid = info_is_valid
  end

  def current_application_form
    @current_application_form ||= ApplicationForm.includes(sections: :fields).where(status: :active).first
  end

  def current_recommender_form
    @current_recommender_form ||= RecommenderForm.includes(sections: :fields).where(status: :active).first
  end

  def complete
    return unless can_complete?
    self.completed!
    self.completed_at = Time.current
  end

  def can_complete?
    self.submitted? &&
      self.application_valid? &&
      self.recommender_statuses.valid_count >= count_of_recommenders
  end

  def submit
    return unless can_submit?
    self.submitted_at = Time.current
    self.submitted!
  end

  def can_submit?
    self.started? &&
      self.application_valid? &&
      current_recommender_form.recommenders_count <= count_of_recommenders
  end

  def withdraw
    self.withdrawn!
  end

  def can_withdraw?
    self.started? || self.submitted? || self.completed?
  end

  def restart
    self.started!
  end

  def can_restart?
    self.withdrawn?
  end

  def count_of_recommenders
    recommender_info.fetch('recommenders_form', []).count
  end

  def data_flattened
    data.each_with_object({}) do |(_, value), hash|
      if value.is_a?(Array)
        value.each_with_index do |v, i|
          hash.merge!(v.transform_keys { |k| k + (i + 1).to_s })
        end
      else
        hash.merge!(value)
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
