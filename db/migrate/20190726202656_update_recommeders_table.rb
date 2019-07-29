class UpdateRecommedersTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :recommenders, :first_name, :string
    remove_column :recommenders, :last_name, :string
    remove_column :recommenders, :title, :string
    remove_column :recommenders, :department, :string
    remove_column :recommenders, :organization, :string
    remove_column :recommenders, :url, :string
    remove_column :recommenders, :phone, :string

    add_column :recommenders, :order, :integer
    add_column :recommenders, :info, :jsonb
    add_column :recommenders, :applicant_id, :integer
    add_column :recommenders, :recomendation_data, :jsonb
  end
end
