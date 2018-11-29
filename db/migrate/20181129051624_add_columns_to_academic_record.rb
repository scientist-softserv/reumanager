class AddColumnsToAcademicRecord < ActiveRecord::Migration
  def change

    add_column :academic_records, :research_interest_1, :string
    add_column :academic_records, :research_interest_2, :string
    add_column :academic_records, :research_interest_3, :string

    add_column :academic_records, :cpu_skills, :text
    add_column :academic_records, :research_experience, :text
    add_column :academic_records, :leadership_experience, :text
    add_column :academic_records, :programming_experience, :text
  end
end
