class ApplicantDatum < ApplicationRecord
  has_one :applicant

  after_initialize do
    self.data = {} if self.data.blank?
    self.recommender_info = {} if self.recommender_info.blank?
  end
end
