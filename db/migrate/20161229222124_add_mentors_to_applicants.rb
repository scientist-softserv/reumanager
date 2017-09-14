class AddMentorsToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :mentor1, :string
    add_column :applicants, :mentor2, :string
  end
end
