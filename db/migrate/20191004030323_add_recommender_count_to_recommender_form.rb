class AddRecommenderCountToRecommenderForm < ActiveRecord::Migration[5.2]
  def change
    add_column :recommender_forms, :recommenders_count, :integer, null: false, default: 1
  end
end
