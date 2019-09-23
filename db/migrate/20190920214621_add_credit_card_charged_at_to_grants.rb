class AddCreditCardChargedAtToGrants < ActiveRecord::Migration[5.2]
  def change
    add_column :grants, :credit_card_charged_at, :datetime
  end
end
