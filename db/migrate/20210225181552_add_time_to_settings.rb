class AddTimeToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :time, :string
  end
end
