# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

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
end

# Admins
admins = [
  { email: 'kelly@notch8.com', first_name: 'Kelly', last_name: 'Chess', password: 'testing123', is_super_admin: true },
  { email: 'rob@notch8.com', first_name: 'Rob', last_name: 'Kaufman', password: 'testing123', grant: grant, is_super_admin: true }
]

admins.map { |user| admin = User.new(user); admin.confirmed_at = DateTime.now; admin.save; }

puts 'test tenant created please use "test.lvh.me" to reach the app'

# Added by Refinery CMS Pages extension
Refinery::Pages::Engine.load_seed
