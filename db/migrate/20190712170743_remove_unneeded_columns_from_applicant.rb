class RemoveUnneededColumnsFromApplicant < ActiveRecord::Migration[5.1]
  def change
    remove_column :applicants, :first_name, :string
    remove_column :applicants, :last_name, :string
    remove_column :applicants, :phone, :string
    remove_column :applicants, :dob, :date
    remove_column :applicants, :citizenship, :string
    remove_column :applicants, :disability, :string
    remove_column :applicants, :gender, :string
    remove_column :applicants, :ethnicity, :string
    remove_column :applicants, :race, :string
    remove_column :applicants, :academic_level, :string
    remove_column :applicants, :lab_skills, :text
    remove_column :applicants, :cpu_skills, :text
    remove_column :applicants, :statement, :text
    remove_column :applicants, :gpa_comment, :text
    remove_column :applicants, :found_us, :string
    remove_column :applicants, :acknowledged_dates, :boolean
    remove_column :applicants, :military, :string
    remove_column :applicants, :mentor1, :string
    remove_column :applicants, :mentor2, :string
  end
end
