class AddAcknowledgedDatesToApplicant < ActiveRecord::Migration
  def change
    add_column :applicants, :acknowledged_dates, :boolean, default: false
  end
end
