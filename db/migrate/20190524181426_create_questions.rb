class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :kind, null: false, default: 'Questions::ShortText'
      t.jsonb :config, null: false, default: {}
      t.integer :section_id, index: true
      t.integer :order, default: 0, null: false

      t.timestamps
    end
  end
end
