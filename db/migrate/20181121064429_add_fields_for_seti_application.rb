class AddFieldsForSetiApplication < ActiveRecord::Migration
  def change
    add_column :applicants, :green_card_holder, :boolean
  end
end
