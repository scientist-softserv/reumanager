class Recommender < ApplicationRecord
  belongs_to :application

  def current_form
    RecommenderForm.where(status: :active).first
  end
end
