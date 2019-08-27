class CreateApplicantData < ActiveRecord::Migration[5.1]
  def change
    create_table :applicant_data do |t|
      t.json :data

      t.timestamps
    end
    add_column :applicants, :applicant_datum_id, :integer
  end
end
