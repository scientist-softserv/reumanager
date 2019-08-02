class ApplicantDatum < ApplicationRecord
  has_one :applicant

  after_initialize do
    self.data = {}
    self.recommender_info = {}
  end
end
