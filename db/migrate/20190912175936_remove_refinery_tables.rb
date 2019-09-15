class RemoveRefineryTables < ActiveRecord::Migration[5.2]
  def up
    remove_column :recommender_statuses, :applicant_id
    drop_table :refinery_authentication_devise_roles
    drop_table :refinery_authentication_devise_roles_users
    drop_table :refinery_authentication_devise_user_plugins
    drop_table :refinery_authentication_devise_users
    drop_table :refinery_images
    drop_table :refinery_page_parts
    drop_table :refinery_pages
    drop_table :refinery_resources
    drop_table :rich_rich_files
    drop_table :awards
    drop_table :academic_records
    drop_table :applicants
    drop_table :program_admins
    drop_table :rails_admin_histories
    drop_table :recommendations
    drop_table :recommenders
  end
end
