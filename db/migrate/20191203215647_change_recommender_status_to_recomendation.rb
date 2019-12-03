class ChangeRecommenderStatusToRecomendation < ActiveRecord::Migration[5.2]
  def change
    rename_table :recommender_statuses, :recommendations
  end
end
