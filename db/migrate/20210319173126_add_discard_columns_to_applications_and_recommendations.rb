class AddDiscardColumnsToApplicationsAndRecommendations < ActiveRecord::Migration[5.2]
  def change
    add_column :applications, :discarded_at, :datetime
    add_index :applications, :discarded_at

    add_column :recommendations, :discarded_at, :datetime
    add_index :recommendations, :discarded_at
  end
end
