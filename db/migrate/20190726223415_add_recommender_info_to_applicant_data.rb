class AddRecommenderInfoToApplicantData < ActiveRecord::Migration[5.2]
  def change
    add_column :applicant_data, :recommender_info, :jsonb
  end
end
