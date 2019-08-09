class Grant < ActiveRecord::Base
  has_many :users
  has_many :settings
  has_many :snippets
  has_many :admin_accounts

  validates :subdomain, exclusion: { in: %w[www admin], message: '%{value} is reserved' }
  validates :subdomain, uniqueness: { scope: :subdomain }
  after_create :create_tenant
  after_destroy :destroy_tenant

  def create_tenant
    Apartment::Tenant.create(subdomain)
    ::GrantDefaultFactory.new(self).create!
    Apartment::Tenant.switch(subdomain) do
      ProjectAdmin.create!(
        first_name: 'Kevin',
        last_name: 'Kochanski',
        email: 'kevin@notch8.com',
        password: 'testing123',
        password_confirmation: 'testing123',
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
end
