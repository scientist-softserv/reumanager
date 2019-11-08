class AddFacingChallengesExperienceToInterests < ActiveRecord::Migration
  def change
    add_column :interests, :facing_challenges_experience, :text
  end
end
