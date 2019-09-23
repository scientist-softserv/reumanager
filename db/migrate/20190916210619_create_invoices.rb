class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.references :grant
      t.string :university_or_institution
      t.string :department
      t.string :program_title
      t.string :contact_name
      t.string :email
      t.string :phone
      t.string :billing_name
      t.text   :billing_address
      t.string :billing_email
      t.string :billing_phone
      t.string :po_number
      # t.date :date_signed

      t.timestamps
    end
  end
end
