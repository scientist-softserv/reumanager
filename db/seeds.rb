# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# if Grant.where(subdomain: 'test').present?
#   Apartment::Tenant.drop('test')
#   Grant.destroy_all
# end

grant = Grant.create(program_title: 'Test Program', subdomain: 'test')

Apartment::Tenant.switch('test') do
  ProgramAdmin.create(
    email: 'admin@test.com',
    first_name: 'Test',
    last_name: 'Admin',
    password: 'testing123',
    password_confirmation: 'testing123',
    confirmed_at: Time.now
  )

  Applicant.create(
    email: 'applicant@test.com',
    password: 'testing123',
    password_confirmation: 'testing123',
    data: {
      profile: {
        first_name: 'John',
        last_name: 'Doe',
        date_of_birth: 18.years.ago,
        phone: '2223334444'
      },
      addresses: [
        {
          type: 'primary',
          street: '123 University Ave',
          city: 'SD',
          state: 'CA',
          zip: '99999'
        },
        {
          type: 'permanent',
          street: '123 Home Ave',
          city: 'SD',
          state: 'CA',
          zip: '99999'
        }
      ],
      academic_record: {
        university: 'Monsters University',
        major: 'Software Engineering',
        minor: 'Scaring',
        gpa: '3.8'
      }
    }
  )

  Applicant.create(
    email: 'applicant+1@test.com',
    password: 'testing123',
    password_confirmation: 'testing123',
    data: {
      profile: {
        first_name: 'Jane',
        last_name: 'Doe',
        date_of_birth: 19.years.ago,
        phone: '2223334444'
      },
      addresses: [
        {
          type: 'primary',
          street: '123 University Ave',
          city: 'SD',
          state: 'CA',
          zip: '99999'
        },
        {
          type: 'permanent',
          street: '123 Home Ave',
          city: 'SD',
          state: 'CA',
          zip: '99999'
        }
      ],
      academic_record: {
        university: 'Monsters University',
        major: 'Software Engineering',
        minor: 'Scaring',
        gpa: '3.9'
      }
    }
  )
  Applicant.create(
    email: 'applicant3@test.com',
    password: 'testing123',
    password_confirmation: 'testing123',
    state: 'completed',
    data: {
      profile: {
        first_name: 'Jane',
        last_name: 'Doe',
        date_of_birth: 19.years.ago,
        phone: '2223334444'
      },
      addresses: [
        {
          type: 'primary',
          street: '123 University Ave',
          city: 'SD',
          state: 'CA',
          zip: '99999'
        },
        {
          type: 'permanent',
          street: '123 Home Ave',
          city: 'SD',
          state: 'CA',
          zip: '99999'
        }
      ],
      academic_record: {
        university: 'Monsters University',
        major: 'Software Engineering',
        minor: 'Scaring',
        gpa: '3.9'
      }
    }
  )
  Applicant.create(
    email: 'applicant4@test.com',
    password: 'testing123',
    password_confirmation: 'testing123',
    state: 'started',
    data: {
      profile: {
        first_name: 'Jane',
        last_name: 'Doe',
        date_of_birth: 19.years.ago,
        phone: '2223334444'
      },
      addresses: [
        {
          type: 'primary',
          street: '123 University Ave',
          city: 'SD',
          state: 'CA',
          zip: '99999'
        },
        {
          type: 'permanent',
          street: '123 Home Ave',
          city: 'SD',
          state: 'CA',
          zip: '99999'
        }
      ],
      academic_record: {
        university: 'Monsters University',
        major: 'Software Engineering',
        minor: 'Scaring',
        gpa: '3.9'
      }
    }
  )
  Applicant.create(
    email: 'applicant5@test.com',
    password: 'testing123',
    password_confirmation: 'testing123',
    state: 'accepted',
    data: {
      profile: {
        first_name: 'Jane',
        last_name: 'Doe',
        date_of_birth: 19.years.ago,
        phone: '2223334444'
      },
      addresses: [
        {
          type: 'primary',
          street: '123 University Ave',
          city: 'SD',
          state: 'CA',
          zip: '99999'
        },
        {
          type: 'permanent',
          street: '123 Home Ave',
          city: 'SD',
          state: 'CA',
          zip: '99999'
        }
      ],
      academic_record: {
        university: 'Monsters University',
        major: 'Software Engineering',
        minor: 'Scaring',
        gpa: '3.9'
      }
    }
  )
  
  Setting.create(name: 'App Title', description: 'A snippet of text that describes your program (e.g. REU in Regenerative Medicine, Multi-Scale Bioengineering, and Systems Biology)')
   Setting.create(name: 'University', description: 'This is used anywhere your university name is referenced.')
   Setting.create(name: 'Department', description: 'This is used anywhere your department name is referenced.')
   Setting.create(name: 'Department Postal Address', description: '')
   Setting.create(name: 'Application Start', description: "This is the 'opening date' for the application system.  After this date, students can apply.  This also controls what buttons are displayed in the navbar and on the homepage (e.g. Apply Now and Login).")
   Setting.create(name: 'Application Deadline', description: 'This date determines when applications can no longer be created or updated. Similar to the above value, buttons to apply are removed after this date.')
   Setting.create(name: 'Notification Date', description: 'This date is used to let the applicants know when to expect a response.  This is used in the confirmation emails.')
   Setting.create(name: 'Program Start Date', description: 'This date is used in the header and confirmation emails to set when the NSFREU program begins.')
   Setting.create(name: 'Program End Date', description: 'Similar to the above value, this marks the end date for your NSFREU program.')
   Setting.create(name: 'Check Back Date', description: "Once the application process is closed (after the application deadline), this value will inform students when to check back for information about next year's application.")
   Setting.create(name:' Mail From', description: 'This will be used in the reply-to value for emails sent from the application.  This is also used in the footer as the email to contact for fields or comments about the website.')
   Setting.create(name: 'Funding Acknowlegement', description: 'Who is supporting this program?')
   Setting.create(name: 'University Url', description: '| Main URL for the parent organization, usually a university (e.g. http://university.edu)')
   Setting.create(name: 'Department Url', description: '| Main URL for the organization, usually a department')
   Setting.create(name: 'Program Url', description: '| URL for the specific program')

end

# Admins
admins = [
  { email: 'super-admin@test.com', first_name: 'super', last_name: 'admin', password: 'testing123', grant: grant, is_super_admin: true }
]

admins.map do |user|
  admin = User.new(user)
  admin.confirmed_at = DateTime.now
  admin.save
end

puts 'test tenant created please use "test.lvh.me" to reach the app'

# Added by Refinery CMS Pages extension
# Refinery::Pages::Engine.load_seed
