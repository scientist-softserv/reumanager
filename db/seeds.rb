# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# if Grant.where(subdomain: 'test').present?
#   Apartment::Tenant.drop('test')
#   Grant.destroy_all
# end

if Apartment::Tenant.current == 'public'
  Grant.destroy_all
  puts 'seeding public schema'
  puts 'create test grant'
  test = Grant.create!(
    program_title: 'Test Program',
    subdomain: 'test',
    admin_first_name: 'Admin',
    admin_last_name: 'Test',
    admin_email: 'admin@test.com',
    admin_password: 'testing123',
    admin_password_confirmation: 'testing123'
  )
  demo = Grant.create!(
    program_title: 'Demo Program',
    subdomain: 'demo',
    admin_first_name: 'Admin',
    admin_last_name: 'Test',
    admin_email: 'admin@test.com',
    admin_password: 'testing123',
    admin_password_confirmation: 'testing123'
  )

  # Super Admin
  puts 'create super admin'
  User.destroy_all
  User.create!(
    email: 'super-admin@test.com',
    first_name: 'super',
    last_name: 'admin',
    password: 'testing123',
    confirmed_at: Time.now
  ).tap { |u| u.add_role(:super) }

  puts 'test tenant created please use "test.lvh.me" to reach the app'
end

if Apartment::Tenant.current == 'test'
  puts 'seeding test schema'

  User.create(
    email: 'User@test.com',
    password: 'testing123',
    password_confirmation: 'testing123',
    confirmed_at: Time.now,
    application: Application.new(
      state: 'started',
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
        academic_record: [{
          university: 'Monsters University',
          major: 'Software Engineering',
          minor: 'Scaring',
          gpa: '3.8'
        }]
      }
    )
  )

  User.create(
    email: 'User+1@test.com',
    password: 'testing123',
    password_confirmation: 'testing123',
    confirmed_at: Time.now,
    application: Application.new(
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
        academic_record: [{
          university: 'Monsters University',
          major: 'Software Engineering',
          minor: 'Scaring',
          gpa: '3.9'
        }]
      }
    )
  )

  User.create(
    email: 'User3@test.com',
    password: 'testing123',
    password_confirmation: 'testing123',
    confirmed_at: Time.now,
    application: Application.new(
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
        academic_record: [{
          university: 'Monsters University',
          major: 'Software Engineering',
          minor: 'Scaring',
          gpa: '3.9'
        }]
      }
    )
  )
end

# Added by Refinery CMS Pages extension
# Refinery::Pages::Engine.load_seed
