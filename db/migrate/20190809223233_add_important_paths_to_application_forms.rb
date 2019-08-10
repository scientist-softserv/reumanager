class AddImportantPathsToApplicationForms < ActiveRecord::Migration[5.2]
  def change
    add_column :application_forms, :important_paths, :jsonb
  end
end
