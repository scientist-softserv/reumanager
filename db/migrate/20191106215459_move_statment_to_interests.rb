class MoveStatmentToInterests < ActiveRecord::Migration
  def up
    add_column :interests, :statement, :text
    execute "UPDATE interests i SET statement = (SELECT a.statement from applicants a WHERE i.applicant_id = a.id);"
    remove_column :applicants, :statement
  end
  def down
    add_column :applicants, :statement, :text
    execute "UPDATE applicants a SET statement = (SELECT i.statement from interests i WHERE a.id = i.applicant_id);"
    remove_column :interests, :statement
  end
end
