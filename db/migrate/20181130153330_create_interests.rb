class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.string :research_interest_1
      t.string :research_interest_2
      t.string :research_interest_3
      t.text :cpu_skills
      t.text :research_experience
      t.text :leadership_experience
      t.text :programming_experience
      t.references :applicant

      t.timestamps
    end
  end
end
