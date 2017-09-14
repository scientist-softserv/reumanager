class AddAcknowledgedDatesToApplicant < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :acknowledged_dates, :boolean, default: false
  end
end
