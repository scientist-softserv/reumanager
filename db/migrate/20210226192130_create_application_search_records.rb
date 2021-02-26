class CreateApplicationSearchRecords < ActiveRecord::Migration[5.2]
  def up
    create_table :application_search_records do |t|
      t.integer :application_id, index: true
      t.text :first_name
      t.text :last_name
      t.text :email

      t.timestamps
    end

    execute <<~SQL
      CREATE INDEX applicant_search_name_index ON application_search_records USING gin ((first_name || ' ' || last_name) public.gin_trgm_ops);
      CREATE INDEX applicant_search_email_index ON application_search_records USING gin (email public.gin_trgm_ops);
    SQL
  end

  def down
    remove_index :application_search_records, :applicant_search_name_index
    remove_index :application_search_records, :applicant_search_email_index

    drop_table :application_search_records
  end
end
