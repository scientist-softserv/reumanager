class AddHandleRecommendationsToRecommenderForms < ActiveRecord::Migration[5.2]
  def change
    add_column :recommender_forms, :handle_recommendations, :boolean, default: true, null: false
  end
end
