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
    Apartment::Tenant.switch(subdomain) do
      ProgramAdmin.create(email: 'kevin@notch8.com', password: 'testing123')
      self.add_default_snippets
      self.add_default_settings
      self.add_default_application_form
      self.add_default_recommenders_form
    end
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
      Snippets::TextSnippet.create(name: 'General Description', description: 'This is the text used as a general description for your program. It is displayed on the front page under the main image.')
      Snippets::TextSnippet.create(name: 'Program Highlights', description: '')
      Snippets::TextSnippet.create(name: 'Eligibility Requirements', description: '')
      Snippets::TextSnippet.create(name: 'Application Information', description: '')
      Snippets::ImageSnippet.create(name: 'Acknowledgment Of Funding Sources', description: 'Please provide text to be included on the site as acknowledgment of program funding. In addition (or instead) you may send an image of the funding agency logo.')
      if self.subdomain == 'test'
        Snippets::TextSnippet.all.each do |s|
          s.value = "#{s.name} - Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
          s.save
        end
      end
    end
  end

  def add_default_settings
    if self.subdomain == 'test'
      application_start = 7.days.ago.strftime('%Y-%m-%d')
      application_deadline = 2.months.from_now.strftime('%Y-%m-%d')
    end
    Setting.transaction do
      Settings::TextSetting.create(name: 'App Title', description: 'A snippet of text that describes your program (e.g. REU in Regenerative Medicine, Multi-Scale Bioengineering, and Systems Biology)')
      Settings::TextSetting.create(name: 'University', description: 'This is used anywhere your university name is referenced.')
      Settings::TextSetting.create(name: 'Department', description: 'This is used anywhere your department name is referenced.')
      Settings::TextSetting.create(name: 'Department Postal Address', description: '')
      Settings::DateSetting.create(name: 'Application Start', description: "This is the 'opening date' for the application system.  After this date, students can apply.  This also controls what buttons are displayed in the navbar and on the homepage (e.g. Apply Now and Login).", value: application_start)
      Settings::DateSetting.create(name: 'Application Deadline', description: 'This date determines when applications can no longer be created or updated. Similar to the above value, buttons to apply are removed after this date.', value: application_deadline)
      Settings::DateSetting.create(name: 'Notification Date', description: 'This date is used to let the applicants know when to expect a response.  This is used in the confirmation emails.')
      Settings::DateSetting.create(name: 'Program Start Date', description: 'This date is used in the header and confirmation emails to set when the NSFREU program begins.')
      Settings::DateSetting.create(name: 'Program End Date', description: 'Similar to the above value, this marks the end date for your NSFREU program.')
      Settings::DateSetting.create(name: 'Check Back Date', description: "Once the application process is closed (after the application deadline), this value will inform students when to check back for information about next year's application.")
      Settings::TextSetting.create(name: 'Mail From', description: 'This will be used in the reply-to value for emails sent from the application.  This is also used in the footer as the email to contact for fields or comments about the website.')
      Settings::TextSetting.create(name: 'Funding Acknowlegement', description: 'Who is supporting this program?')
      Settings::TextSetting.create(name: 'University Url', description: '| Main URL for the parent organization, usually a university (e.g. http://university.edu)')
      Settings::TextSetting.create(name: 'Department Url', description: '| Main URL for the organization, usually a department')
      Settings::TextSetting.create(name: 'Program Url', description: '| URL for the specific program')
    end
  end
end
