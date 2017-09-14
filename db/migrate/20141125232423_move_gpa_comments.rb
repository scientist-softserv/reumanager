class MoveGpaComments < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :gpa_comment, :text
  end
end
