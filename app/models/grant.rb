class Grant < ActiveRecord::Base
  has_many :users
  has_many :settings
  has_many :snippets
  has_many :admin_accounts

  validates :subdomain, exclusion: { in: %w(www admin), message: "%{value} is reserved"}
  validates :subdomain, uniqueness: {:scope => :subdomain}
  after_create :add_default_snippets
  after_create :create_tenant
  after_destroy :destroy_tenant
  accepts_nested_attributes_for :settings
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :snippets
  accepts_nested_attributes_for :admin_accounts

  def create_tenant
    Apartment::Tenant.create(subdomain)
    Apartment::Tenant.switch!(subdomain)
    Setting.load_from_yaml(self)
    Snippet.load_from_yaml(self)
    Apartment::Tenant.switch!
  end

  def destroy_tenant
    Apartment::Tenant.drop(subdomain)
  end

  def add_default_snippets
    Snippet.create(name: 'General Description', description: 'This is the text used as a general description for your program. It is displayed on the front page under the main image.', grant_id: self.id)
    Snippet.create(name: 'Program Highlights', description: '', grant_id: self.id)
    Snippet.create(name: 'Eligibility Requirements', description: '', grant_id: self.id)
    Snippet.create(name: 'Application Information', description: '', grant_id: self.id)
    Snippet.create(name: 'Acknowledgment Of Funding Sources', description: 'Please provide text to be included on the site as acknowledgment of program funding. In addition (or instead) you may send an image of the funding agency logo.', grant_id: self.id)
  end
end
