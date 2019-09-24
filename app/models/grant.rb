class Grant < ActiveRecord::Base
  has_many :users
  has_many :settings
  has_many :snippets
  has_many :program_admins
  has_many :invoices

  validates :subdomain, exclusion: { in: %w[www admin], message: '%{value} is reserved' }
  validates :subdomain, uniqueness: { scope: :subdomain }
  after_create :create_tenant
  after_destroy :destroy_tenant
  attr_accessor :admin_first_name, :admin_last_name, :admin_password, :admin_password_confirmation, :admin_email

  def create_tenant
    Apartment::Tenant.create(subdomain)
    ::GrantDefaultFactory.new(self).create!
    Apartment::Tenant.switch(subdomain) do
      ::ProgramAdmin.create!(
        first_name: self.admin_first_name,
        last_name: self.admin_last_name,
        email: self.admin_email,
        password: self.admin_password,
        password_confirmation: self.admin_password_confirmation,
        confirmed_at: Time.now,
        super: true
      )
    end
  end

  def destroy_tenant
    Apartment::Tenant.drop(subdomain)
  end

  def reset_defaults
    ::GrantDefaultFactory.new(self).reset!
  end

  def switch!
    Apartment::Tenant.switch!(self.subdomain)
  end

  def latest_invoice
    @latest_invoice ||= invoices.last
  end

  def charged_credit_card?
    credit_card_charged_at.present?
  end
end
