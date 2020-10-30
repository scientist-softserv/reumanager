FactoryBot.define do
  factory :field, class: Fields::ShortText do
    # we need a differnet name for each field so ... pokemon names
    config { { title: Faker::Games::Pokemon.name.parameterize } }
  end

  factory :long_text_field, class: Fields::LongText do
    # we need a differnet name for each field so ... pokemon names
    config { { title: Faker::Games::Pokemon.name.parameterize } }
  end

  factory :select_field, class: Fields::Select do
    config do
      {
        title: 'GPA',
        description: 'Select your GPA',
        enum_array: ['1.0', '2.0', '3.0', '4.0']
      }
    end
  end
end
