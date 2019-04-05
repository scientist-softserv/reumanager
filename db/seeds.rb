# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

grant = Grant.create(program_title: 'Test Program', subdomain: 'test')

Apartment::Tenant.switch('test') do
  # Admins
  admins = [
    { email: 'kelly@notch8.com', first_name: 'Kelly', last_name: 'Chess', password: 'testing123', grant: grant },
    { email: 'rob@notch8.com', first_name: 'Rob', last_name: 'Kaufman', password: 'testing123', grant: grant }
  ]

  admins.map { |user| admin = User.new(user); admin.confirmed_at = DateTime.now; admin.save; }
end

puts 'test tenant created please use "test.lvh.me" to reach the app'

# Added by Refinery CMS Pages extension
Refinery::Pages::Engine.load_seed
