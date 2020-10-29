class GrantDefaultFactory
  attr_reader :grant

  def initialize(grant)
    @grant = grant
  end

  def create!
    Apartment::Tenant.switch(grant.subdomain) do
      create_default_snippets
      create_default_settings
      create_default_application_form
      create_default_recommenders_form
    end
  end

  def reset!
    Apartment::Tenant.switch(grant.subdomain) do
      destroy_things!
      create_default_snippets
      create_default_settings
      create_default_application_form
      create_default_recommenders_form
    end
  end

  private

  def destroy_things!
    Snippet.destroy_all
    Setting.destroy_all
    ApplicationForm.destroy_all
    RecommenderForm.destroy_all
  end

  def create_default_application_form
    ApplicationForm.transaction do
      af = ApplicationForm.create!(name: 'Application Default', status: :active)
      s1 = Section.create!(title: 'Profile', important: 'profile', application_form: af)
      Fields::ShortText.create!(title: 'First Name', important: 'profile_first_name', order: 1, section: s1)
      Fields::ShortText.create!(title: 'Last Name', important: 'profile_last_name', order: 2, section: s1)
      Fields::ShortText.create!(title: 'Phone', order: 3, section: s1)
      Fields::ShortText.create!(title: 'Contact Email', order: 4, section: s1)
      Fields::Date.create!(title: 'Date of Birth', order: 5, section: s1)
      s2 = Section.create!(title: 'Addresses', repeating: true, application_form: af)
      Fields::ShortText.create!(title: 'Type', order: 1, section: s2)
      Fields::ShortText.create!(title: 'Street', order: 2, section: s2)
      Fields::ShortText.create!(title: 'City', order: 3, section: s2)
      Fields::ShortText.create!(title: 'State', order: 4, section: s2)
      Fields::ShortText.create!(title: 'Zip', order: 5, section: s2)
      s3 = Section.create!(title: 'Academic Record', repeating: true, application_form: af)
      Fields::ShortText.create!(title: 'University', order: 1, section: s3)
      Fields::Select.create!(title: 'GPA', enum_array: %w[4.0 3.9 3.8 3.7 3.6 3.5 3.4 3.3 3.2 3.1 3.0 2.9 2.8 2.7 2.6 2.5 2.4 2.3 2.2 2.1 1.0 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1 0.0], order: 2, section: s3)
      Fields::Date.create!(title: 'Started University', order: 3, section: s3)
      Fields::Date.create!(title: 'Estimated Graduation Date', order: 3, section: s3)
      Fields::File.create!(title: 'Transcript', order: 4, section: s3)
      s4 = Section.create!(title: 'Essay Questions', repeating: false, application_form: af)
      Fields::LongText.create(title: 'Essay 1', max_length: 1000, order: 1, section: s4)
      Fields::LongText.create(title: 'Essay 2', max_length: 1000, order: 2, section: s4)

      Rails.logger.info("New default ApplicationForm created, ID: #{af.id}")
    end
  end

  def create_default_recommenders_form
    RecommenderForm.transaction do
      rf = RecommenderForm.create!(name: 'Default', status: :active)
      s1 = Section.create!(title: 'Recommenders Form', repeating: true, recommender_form: rf, important: 'recommender')
      Fields::ShortText.create!(title: 'First Name', order: 1, section: s1, important: 'recommender_first_name')
      Fields::ShortText.create!(title: 'Last Name', order: 2, section: s1, important: 'recommender_last_name')
      Fields::ShortText.create!(title: 'Email', order: 3, section: s1, important: 'recommeder_email')
      Fields::ShortText.create!(title: 'Organization', order: 4, section: s1)

      s2 = Section.create!(title: 'Recommendation Form', repeating: false, recommender_form: rf, important: 'recommendation')
      Fields::Select.create!(title: 'Known Applicant For', enum_array: ['less than 1 year', '1-2 years', '3-4 years', '5+ years'], order: 1, section: s2)
      Fields::Select.create!(title: 'Applicants Promise', enum_array: ['above average', 'average', 'below average'], order: 2, section: s2)
      Fields::LongText.create!(title: 'Recommendation', order: 4, section: s2)
      Rails.logger.info("New default RecommenderForm created, ID: #{rf.id}")
    end
  end

  def create_default_snippets
    Snippet.transaction do
      Snippets::TextSnippet.create!(text_snippets)
      Snippets::ImageSnippet.create!(image_snippets)
    end
    Rails.logger.info("New default snippets created: #{Snippet.pluck(:name).join(', ')}")
  end

  def create_default_settings
    Setting.transaction do
      Settings::DateSetting.create!(date_settings)
      Settings::TextSetting.create!(text_settings)
      Settings::UrlSetting.create!(url_settings)
    end
    Rails.logger.info("New default settings created: #{Setting.pluck(:name, :value).map { |e| e.join('-') }.join(', ')}")
  end

  def text_snippets
    text_snippets = [
      { name: 'General Description', description: 'This is the text used as a general description for your program. It is displayed on the front page under the main image.' },
      { name: 'Program Highlights', description: 'Content for the Program highlights section of the programs home page' },
      { name: 'Eligibility Requirements', description: 'Content for the Eligibility Requirements section of the programs home page' },
      { name: 'Application Information', description: 'Content for the Application Information section of the programs home page' },
      { name: 'Acknowledgment Of Funding Sources', description: 'Please provide text to be included on the site as acknowledgment of program funding. In addition (or instead) you may send an image of the funding agency logo.' }
    ]
    if grant.subdomain == 'test'
      text_snippets.each do |a|
        a[:value] = "#{a[:name]} - Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
      end
    end
    text_snippets
  end

  def image_snippets
    [
      { name: 'Home Page Image', description: 'Image for the home page' }
    ]
  end

  def date_settings
    if grant.subdomain == 'test'
      application_start = 7.days.ago.strftime('%Y-%m-%d')
      application_deadline = 2.months.from_now.strftime('%Y-%m-%d')
    end
    [
      { name: 'Application Start', description: "This is the 'opening date' for the application system.  After this date, students can apply.  This also controls what buttons are displayed in the navbar and on the homepage (e.g. Apply Now and Login).", value: application_start },
      { name: 'Application Deadline', description: 'This date determines when applications can no longer be created or updated. Similar to the above value, buttons to apply are removed after this date.', value: application_deadline },
      { name: 'Notification Date', description: 'This date is used to let the applicants know when to expect a response.  This is used in the confirmation emails.' },
      { name: 'Program Start Date', description: 'This date is used in the header and confirmation emails to set when the NSFREU program begins.' },
      { name: 'Program End Date', description: 'Similar to the above value, this marks the end date for your NSFREU program.' },
      { name: 'Check Back Date', description: "Once the application process is closed (after the application deadline), this value will inform students when to check back for information about next year's application." }
    ]
  end

  def text_settings
    [
      { name: 'App Title', description: 'A snippet of text that describes your program (e.g. REU in Regenerative Medicine, Multi-Scale Bioengineering, and Systems Biology)' },
      { name: 'University', description: 'This is used anywhere your university name is referenced.' },
      { name: 'Department', description: 'This is used anywhere your department name is referenced.' },
      { name: 'Department Postal Address', description: "The postal address for the program's mail" },
      { name: 'Mail From', description: 'This will be used in the reply-to value for emails sent from the application.  This is also used in the footer as the email to contact for fields or comments about the website.' },
      { name: 'Funding Acknowlegement', description: 'Who is supporting this program?' }
    ]
  end

  def url_settings
    [
      { name: 'University Url', description: 'Main URL for the parent organization, usually a university (e.g. http://university.edu)' },
      { name: 'Department Url', description: 'Main URL for the organization, usually a department' },
      { name: 'Program Url', description: 'URL for the specific program' }
    ]
  end
end
