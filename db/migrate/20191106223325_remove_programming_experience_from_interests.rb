class RemoveProgrammingExperienceFromInterests < ActiveRecord::Migration
  def change
    remove_column :interests, :programming_experience, :text
  end
end
