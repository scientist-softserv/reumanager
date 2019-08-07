# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# if Grant.where(subdomain: 'test').present?
#   Apartment::Tenant.drop('test')
#   Grant.destroy_all
# end

if Apartment::Tenant.current == 'public'
  puts 'seeding public schema'
  puts 'create test grant'
  Grant.create(program_title: 'Test Program', subdomain: 'test')

  # Super Admin
  puts 'create super admin'
  User.new(
    email: 'super-admin@test.com',
    first_name: 'super',
    last_name: 'admin',
    password: 'testing123',
    confirmed_at: Time.now
  )

  puts 'test tenant created please use "test.lvh.me" to reach the app'
end

if Apartment::Tenant.current == 'test'
  puts 'seeding test schema'

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
    confirmed_at: Time.now
  ).tap do |a|
    a.data = {
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
    a.save
  end

  Applicant.create(
    email: 'applicant+1@test.com',
    password: 'testing123',
    password_confirmation: 'testing123',
    confirmed_at: Time.now
  ).tap do |a|
    a.data = {
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
    a.save
  end


  Applicant.create(
    email: 'applicant3@test.com',
    password: 'testing123',
    password_confirmation: 'testing123',
    state: 'completed',
    confirmed_at: Time.now
  ).tap do |a|
    a.data = {
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
    a.save
  end

  Applicant.create(
    email: 'applicant4@test.com',
    password: 'testing123',
    password_confirmation: 'testing123',
    state: 'started',
    confirmed_at: Time.now
  ).tap do |a|
    a.data = {
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
    a.save
  end

  Applicant.create(
    email: 'applicant5@test.com',
    password: 'testing123',
    password_confirmation: 'testing123',
    state: 'accepted',
    confirmed_at: Time.now
  ).tap do |a|
    a.data = {
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
    a.save
  end
end

# Added by Refinery CMS Pages extension
# Refinery::Pages::Engine.load_seed
