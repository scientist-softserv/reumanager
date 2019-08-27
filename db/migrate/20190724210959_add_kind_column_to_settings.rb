class AddKindColumnToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :kind, :string
  end
end
