class NewFieldsForSetiApplication < ActiveRecord::Migration
  def change
    add_column :applicants, :cell_phone, :string
    add_column :applicants, :member_of_lgbt_community, :boolean
    add_column :applicants, :fathers_highest_education, :string
    add_column :applicants, :mothers_highest_education, :string
    add_column :applicants, :veteran_information, :string

    add_column :applicants, :research_interest_1, :string
    add_column :applicants, :research_interest_2, :string
    add_column :applicants, :research_interest_3, :string
    add_column :applicants, :research_interest_4, :string
    add_column :applicants, :research_interest_5, :string

    add_column :applicants, :research_experience, :text
    add_column :applicants, :leadership_experience, :text
    add_column :applicants, :programming_experience, :text
    add_column :applicants, :previous_math_science_experience, :text

    add_column :recommenders, :address, :string
    add_column :recommenders, :city, :string
    add_column :recommenders, :state, :string
    add_column :recommenders, :zip, :string
    add_column :recommenders, :country, :string
  end
end
