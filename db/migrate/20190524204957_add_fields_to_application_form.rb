class AddFieldsToApplicationForm < ActiveRecord::Migration[5.1]
  def change
    add_column :application_forms, :name, :string
    add_column :application_forms, :status, :integer, default: 0, null: false
  end
end
