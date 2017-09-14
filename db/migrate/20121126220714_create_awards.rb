class CreateAwards < ActiveRecord::Migration[4.2]
  def change
    create_table :awards do |t|
      t.string :title
      t.date :date
      t.text :description
      t.integer :applicant_id

      t.timestamps
    end
  end
end
