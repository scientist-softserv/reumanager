class RemoveValidFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :applications, :application_valid, :boolean, null: false, default: false
    remove_column :applications, :data_valid, :boolean, null: false, default: false
    remove_column :applications, :recommender_info_valid, :boolean, null: false, default: false

    remove_column :recommender_statuses, :data_valid, :boolean, null: false, default: false
  end
end
