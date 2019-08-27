class AddMoreDeviseColumnsToProgramAdmin < ActiveRecord::Migration[5.2]
  def change
    add_column :program_admins, :super, :boolean, default: false, null: false

    # Trackable
    add_column :program_admins, :sign_in_count, :integer, default: 0, null: false
    add_column :program_admins, :current_sign_in_at, :datetime
    add_column :program_admins, :current_sign_in_ip, :inet
    add_column :program_admins, :last_sign_in_at, :datetime
    add_column :program_admins, :last_sign_in_ip, :inet

    # Lockable
    add_column :program_admins, :failed_attempts, :integer, default: 0, null: false
    add_column :program_admins, :unlock_token, :string
    add_column :program_admins, :locked_at, :datetime

    # Indexes
    add_index :program_admins, :confirmation_token, unique: true
    add_index :program_admins, :unlock_token, unique: true
  end
end
