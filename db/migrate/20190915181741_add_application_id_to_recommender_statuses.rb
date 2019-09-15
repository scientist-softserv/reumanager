class AddApplicationIdToRecommenderStatuses < ActiveRecord::Migration[5.2]
  def change
    add_column :recommender_statuses, :application_id, :integer
  end
end
