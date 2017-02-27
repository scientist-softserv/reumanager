# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Admins
admins = [{ email: 'dr.stegman@gmail.com', first_name: 'Dave', last_name: 'Stegman', password: 'REUappUCSD'},
          { email: 'crystal@notch8.com', first_name: 'Crystal', last_name: 'Richardson', password: 'REUappUCSD' },
          { email: 'rob@notch8.com', first_name: 'Rob', last_name: 'Kaufman', password: 'testing123' }]

admins.map { |user| admin = User.new(user); admin.confirmed_at = DateTime.now; admin.save; }

# Demo Applicants
10.times do
  FactoryGirl.create(:applicant)
  FactoryGirl.create(:applicant_with_address)
  FactoryGirl.create(:applicant_with_address_and_record)
  FactoryGirl.create(:applicant_with_address_record_and_recommender)
  FactoryGirl.create(:applicant_with_recommender_and_recommendation)
  FactoryGirl.create(:applicant_with_address_record_recommender_and_recommendation)
end
