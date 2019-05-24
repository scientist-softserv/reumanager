class CreateSections < ActiveRecord::Migration[5.1]
  def change
    create_table :sections do |t|
      t.text :title, null: false
      t.boolean :repeating, default: false, null: false
      t.integer :application_form_id, index: true

      t.timestamps
    end
  end
end
