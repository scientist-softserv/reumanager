class Invoice < ApplicationRecord
  belongs_to :grant

  validates :university_or_institution, :department, :program_title,
            :contact_name, :email, :phone, :billing_name, :billing_address,
            :billing_email, :billing_phone, :po_number,
            presence: true
end
