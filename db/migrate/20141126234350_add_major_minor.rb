class AddMajorMinor < ActiveRecord::Migration[4.2]
  def change
    add_column :academic_records, :major, :string
    add_column :academic_records, :minor, :string
  end
end
