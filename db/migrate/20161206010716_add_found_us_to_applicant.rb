class AddFoundUsToApplicant < ActiveRecord::Migration
  def change
    add_column :applicants, :found_us, :string
  end
end
