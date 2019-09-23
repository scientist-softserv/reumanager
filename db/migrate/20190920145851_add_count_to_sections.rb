class AddCountToSections < ActiveRecord::Migration[5.2]
  def change
    add_column :sections, :count, :integer, default: 1, null: false
  end
end
