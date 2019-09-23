class AddDependantIdToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :dependant_id, :integer, index: true
  end
end
