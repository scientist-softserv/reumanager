class UpdateUserTableToRuleThemAll < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :grant_id, :integer
    remove_column :users, :is_super_admin, :boolean
    remove_column :users, :authentication_token, :string

    add_column :users, :applicant_datum_id, :integer
  end
end
