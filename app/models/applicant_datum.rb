class ApplicantDatum < ApplicationRecord
  has_one :applicant

  after_initialize do
    self.data = {} if self.data.blank?
    self.recommender_info = {} if self.recommender_info.blank?
  end

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
end
