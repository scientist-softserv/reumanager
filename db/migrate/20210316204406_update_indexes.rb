class UpdateIndexes < ActiveRecord::Migration[5.2]
  def up
    disable_extension('pg_trgm') if extensions.include?('pg_trgm')
    remove_index :application_search_records, name: :applicant_search_name_index if index_exists?(:application_search_records, name: :applicant_search_name_index)
    remove_index :application_search_records, name: :applicant_search_email_index if index_exists?(:application_search_records, name: :applicant_search_email_index)
  end

  def down; end
end
