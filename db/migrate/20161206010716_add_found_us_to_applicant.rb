class AddFoundUsToApplicant < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :found_us, :string
  end
end
