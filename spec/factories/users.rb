FactoryBot.define do
  factory :user, class: User do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    email                 { Faker::Internet.email }
    password              { 'testing123' }
    password_confirmation { 'testing123' }
    confirmed_at          { 20.days.ago }
  end
end
