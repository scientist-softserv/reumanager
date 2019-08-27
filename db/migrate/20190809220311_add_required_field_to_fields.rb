class AddRequiredFieldToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :important, :string
  end
end
