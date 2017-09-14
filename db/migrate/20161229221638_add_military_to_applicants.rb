class AddMilitaryToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :military, :string
  end
end
