class RenameApplicantData < ActiveRecord::Migration[5.2]
  def change
    rename_table :applicant_data, :applications
    rename_column :users, :applicant_datum_id, :application_id
  end
end
