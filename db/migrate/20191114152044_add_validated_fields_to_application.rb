class AddValidatedFieldsToApplication < ActiveRecord::Migration[5.2]
  def change
    add_column :applications, :application_valid, :boolean, null: false, default: false
    add_column :applications, :data_valid, :boolean, null: false, default: false
    add_column :applications, :recommender_info_valid, :boolean, null: false, default: false

    add_column :recommender_statuses, :data_valid, :boolean, null: false, default: false
  end
end
