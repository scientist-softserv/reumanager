class Grant < ActiveRecord::Base
  has_many :users
  has_many :settings
  has_many :snippets
  has_many :admin_accounts

  validates :subdomain, exclusion: { in: %w[www admin], message: '%{value} is reserved' }
  validates :subdomain, uniqueness: { scope: :subdomain }
  after_create :add_default_snippets
  after_create :add_default_settings
  after_create :create_tenant
  after_destroy :destroy_tenant
  accepts_nested_attributes_for :settings
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :snippets
  accepts_nested_attributes_for :admin_accounts

  def create_tenant
    Apartment::Tenant.create(subdomain)
    Apartment::Tenant.switch!(subdomain)
    Apartment::Tenant.switch!
  end

  def destroy_tenant
    Apartment::Tenant.drop(subdomain)
  end

  def reset_defaults
    Apartment::Tenant.switch(self.subdomain) do
      Snippet.destroy_all
      self.add_default_snippets
      Setting.destroy_all
      self.add_default_settings
      ApplicationForm.destroy_all
      self.add_default_application_form
      RecommenderForm.destroy_all
      self.add_default_recommenders_form
    end
  end

  def add_default_application_form
    ApplicationForm.transaction do
      af = ApplicationForm.create(name: 'Application Default', status: :draft)
      s1 = Section.new(title: 'Profile', application_form: af)
      Fields::ShortText.new(title: 'First Name', format: 'text', order: 1, section: s1)
      Fields::ShortText.new(title: 'Last Name', format: 'text', order: 2, section: s1)
      Fields::ShortText.new(title: 'Phone', format: 'text', order: 3, section: s1)
      Fields::ShortText.new(title: 'Date of Birth', format: 'date', order: 4, section: s1)
      s2 = Section.new(title: 'Addresses', repeating: true, application_form: af)
      Fields::ShortText.new(title: 'Type', format: 'text', order: 1, section: s2)
      Fields::ShortText.new(title: 'Street', format: 'text', order: 2, section: s2)
      Fields::ShortText.new(title: 'City', format: 'text', order: 3, section: s2)
      Fields::ShortText.new(title: 'State', format: 'text', order: 4, section: s2)
      Fields::ShortText.new(title: 'Zip', format: 'text', order: 5, section: s2)
    end
  end

  def add_default_recommenders_form
    RecommenderForm.transaction do
      rf = RecommenderForm.create!(name: 'Default', status: :active)
      s1 = Section.create!(title: 'Recommenders Form', repeating: true, recommender_form: rf)
      Fields::ShortText.create!(title: 'First Name', format: 'text', order: 1, section: s1)
      Fields::ShortText.create!(title: 'Last Name', format: 'text', order: 2, section: s1)
      Fields::ShortText.create!(title: 'Email', format: 'text', order: 3, section: s1)
      Fields::ShortText.create!(title: 'Organization', format: 'text', order: 4, section: s1)
      s2 = Section.create!( title: 'Recommendation Form', repeating: true, recommender_form: rf)
      Fields::ShortText.create!(title: 'Known Applicant For', format: 'text', order: 1, section: s2)
      Fields::ShortText.create!(title: 'Applicants Promise', format: 'text', order: 2, section: s2)
      Fields::ShortText.create!(title: "Organization's Focus", format: 'text', order: 3, section: s2)
      Fields::LongText.create!(title: 'Recommendation', order: 4, section: s2)
    end
  end

  def add_default_snippets
    Snippet.transaction do
      Snippets::TextSnippet.create(name: 'General Description', description: 'This is the text used as a general description for your program. It is displayed on the front page under the main image.', grant_id: self.id)
      Snippets::TextSnippet.create(name: 'Program Highlights', description: '', grant_id: self.id)
      Snippets::TextSnippet.create(name: 'Eligibility Requirements', description: '', grant_id: self.id)
      Snippets::TextSnippet.create(name: 'Application Information', description: '', grant_id: self.id)
      Snippets::ImageSnippet.create(name: 'Acknowledgment Of Funding Sources', description: 'Please provide text to be included on the site as acknowledgment of program funding. In addition (or instead) you may send an image of the funding agency logo.', grant_id: self.id)
    end
  end

  def add_default_settings
    Setting.transaction do
      Settings::TextSetting.create(name: 'App Title', description: 'A snippet of text that describes your program (e.g. REU in Regenerative Medicine, Multi-Scale Bioengineering, and Systems Biology)', grant_id: self.id)
      Settings::TextSetting.create(name: 'University', description: 'This is used anywhere your university name is referenced.', grant_id: self.id)
      Settings::TextSetting.create(name: 'Department', description: 'This is used anywhere your department name is referenced.', grant_id: self.id)
      Settings::TextSetting.create(name: 'Department Postal Address', description: '', grant_id: self.id)
      Settings::DateSetting.create(name: 'Application Start', description: "This is the 'opening date' for the application system.  After this date, students can apply.  This also controls what buttons are displayed in the navbar and on the homepage (e.g. Apply Now and Login).", grant_id: self.id)
      Settings::DateSetting.create(name: 'Application Deadline', description: 'This date determines when applications can no longer be created or updated. Similar to the above value, buttons to apply are removed after this date.', grant_id: self.id)
      Settings::DateSetting.create(name: 'Notification Date', description: 'This date is used to let the applicants know when to expect a response.  This is used in the confirmation emails.', grant_id: self.id)
      Settings::DateSetting.create(name: 'Program Start Date', description: 'This date is used in the header and confirmation emails to set when the NSFREU program begins.', grant_id: self.id)
      Settings::DateSetting.create(name: 'Program End Date', description: 'Similar to the above value, this marks the end date for your NSFREU program.', grant_id: self.id)
      Settings::DateSetting.create(name: 'Check Back Date', description: "Once the application process is closed (after the application deadline), this value will inform students when to check back for information about next year's application.",grant_id: self.id)
      Settings::TextSetting.create(name:' Mail From', description: 'This will be used in the reply-to value for emails sent from the application.  This is also used in the footer as the email to contact for fields or comments about the website.', grant_id: self.id)
      Settings::TextSetting.create(name: 'Funding Acknowlegement', description: 'Who is supporting this program?', grant_id: self.id)
      Settings::TextSetting.create(name: 'University Url', description: '| Main URL for the parent organization, usually a university (e.g. http://university.edu)', grant_id: self.id)
      Settings::TextSetting.create(name: 'Department Url', description: '| Main URL for the organization, usually a department', grant_id: self.id)
      Settings::TextSetting.create(name: 'Program Url', description: '| URL for the specific program', grant_id: self.id)
    end
  end
end
