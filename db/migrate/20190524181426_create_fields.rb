class CreateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :fields do |t|
      t.string :kind, null: false, default: 'Fields::ShortText'
      t.jsonb :config, null: false, default: {}
      t.integer :section_id, index: true
      t.integer :order, default: 0, null: false

      t.timestamps
    end
  end
end
