class RemoveColumnsFromApplicant < ActiveRecord::Migration
  def change
    remove_column :applicants, :cpu_skills, :text
    remove_column :applicants, :research_interest_1, :string
    remove_column :applicants, :research_interest_2, :string
    remove_column :applicants, :research_interest_3, :string
    remove_column :applicants, :research_interest_4, :string
    remove_column :applicants, :research_interest_5, :string

    remove_column :applicants, :research_experience, :text
    remove_column :applicants, :leadership_experience, :text
    remove_column :applicants, :programming_experience, :text
    remove_column :applicants, :previous_math_science_experience, :text
  end
end
