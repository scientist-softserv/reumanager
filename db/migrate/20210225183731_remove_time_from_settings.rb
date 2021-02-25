class RemoveTimeFromSettings < ActiveRecord::Migration[5.2]
  def change
    remove_column :settings, :time
  end
end
