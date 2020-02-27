FactoryBot.define do
  factory :setting, class: Setting do
    name { 'App Title Test' }
    description { 'Description of test app title setting' }

    trait :with_value do
      value { 'This is the test app title' }
    end
  end
end
