class AddMilitaryToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :military, :string
  end
end
