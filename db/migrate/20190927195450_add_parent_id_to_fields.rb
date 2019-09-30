class AddParentIdToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :parent_id, :integer, index: true
    add_column :fields, :parent_value, :integer
    remove_column :fields, :dependant_id, :integer
  end
end
