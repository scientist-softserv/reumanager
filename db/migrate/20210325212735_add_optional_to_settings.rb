class AddOptionalToSettings < ActiveRecord::Migration[5.2]
  def up
    add_column :settings, :optional, :boolean, default: false, null: false
    Setting.find_by(name: 'Notification Date')&.update(optional: true)
  end

  def down
    remove_column :settings, :optional, :boolean, default: false, null: false
  end
end
