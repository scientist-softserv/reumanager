class AddRequiredFieldToSections < ActiveRecord::Migration[5.2]
  def change
    add_column :sections, :important, :string
  end
end
