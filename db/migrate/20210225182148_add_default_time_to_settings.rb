class AddDefaultTimeToSettings < ActiveRecord::Migration[5.2]
  def change
    change_column :settings, :time, :string, default: '23:59'
  end
end
