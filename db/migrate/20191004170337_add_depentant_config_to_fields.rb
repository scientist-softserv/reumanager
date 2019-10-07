class AddDepentantConfigToFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :fields, :parent_id, :integer
    remove_column :fields, :parent_value, :string
    add_column :fields, :dependant_config, :jsonb, default: {}
  end
end
