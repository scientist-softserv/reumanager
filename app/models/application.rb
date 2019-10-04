class Application < ApplicationRecord
  has_one :user

  after_initialize do
    self.data = {} if self.data.blank?
    self.recommender_info = {} if self.recommender_info.blank?
  end

  has_many :recommender_statuses, dependent: :destroy

  enum state: {
    'started' => 'started',
    'submitted' => 'submitted',
    'completed' => 'completed',
    'withdrawn' => 'withdrawn',
    'accepted' => 'accepted',
    'rejected' => 'rejected'
  }

  after_save :update_recommender_status

  def update_recommender_status
    return unless self.recommender_info_previously_changed?
    return if self.recommender_info['recommenders_form'].blank?
    emails = self.recommender_info['recommenders_form'].map { |r| r['Email'] }.compact
    statuses = self.applicant.recommender_statuses.to_a
    current_emails = statuses.map(&:email)
    missing_emails = emails.difference(current_emails)
    missing_emails.each do |email|
      RecommenderStatus.create(email: email, applicant: self.applicant)
    end
    statuses.each do |status|
      status.destroy unless emails.include?(status.email)
    end
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
