class CreateRecommenderForms < ActiveRecord::Migration[5.2]
  def change
    create_table :recommender_forms do |t|
      t.integer :status
      t.string :name
      t.jsonb :form_json_schema
      t.jsonb :form_ui_schema
      t.datetime :updated_cache_at
      t.timestamps
    end
  end
end
