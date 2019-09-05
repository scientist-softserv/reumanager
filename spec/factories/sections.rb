FactoryBot.define do
    factory :section, class: Section do
        title {"profile"}
        transient do
            fields_count {3}
        end
        after(:create) do |section, evaluator|
            create_list :field, evaluator.fields_count, section: section
        end
    end 
end 
