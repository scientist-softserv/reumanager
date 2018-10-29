# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Admins
admins = [
  { email: 'matt@seti.org', first_name: 'Matthew', last_name: 'Tiscareno', password: 'REUappSETI'},
  { email: 'kelly@notch8.com', first_name: 'Kelly', last_name: 'Chess', password: 'REUappSETI' },
  { email: 'rob@notch8.com', first_name: 'Rob', last_name: 'Kaufman', password: 'testing123' }
]

admins.each do |user|
  User.new(user).tap do |a|
    a.confirmed_at = DateTime.now
    a.save
  end
end

# Demo Applicants
10.times do
  FactoryGirl.create(:applicant)
  FactoryGirl.create(:applicant_with_address)
  FactoryGirl.create(:applicant_with_address_and_record)
  FactoryGirl.create(:applicant_with_address_record_and_recommender)
  FactoryGirl.create(:applicant_with_recommender_and_recommendation)
  FactoryGirl.create(:applicant_with_address_record_recommender_and_recommendation)
end
