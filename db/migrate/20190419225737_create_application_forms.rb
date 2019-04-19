class CreateApplicationForms < ActiveRecord::Migration[5.1]
  def change
    create_table :application_forms do |t|
      t.json :form_schema
      t.json :form_ui_schema

      t.timestamps
    end
  end
end
