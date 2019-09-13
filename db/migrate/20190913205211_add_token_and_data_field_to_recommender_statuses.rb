class AddTokenAndDataFieldToRecommenderStatuses < ActiveRecord::Migration[5.2]
  def change
    add_column :recommender_statuses, :token, :string, default: -> { 'MD5(random()::text)' }, null: false
    add_column :recommender_statuses, :data, :jsonb, default: {}
  end
end
