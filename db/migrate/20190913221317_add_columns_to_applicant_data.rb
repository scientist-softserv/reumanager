class AddColumnsToApplicantData < ActiveRecord::Migration[5.2]
  def change
    add_column :applicant_data, :submitted_at, :datetime
    add_column :applicant_data, :completed_at, :datetime
    add_column :applicant_data, :state, :string
  end
end
