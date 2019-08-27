class Recommender < ApplicationRecord
  belongs_to :applicant

  def current_form
    RecommenderForm.where(status: :active).first
  end
end
