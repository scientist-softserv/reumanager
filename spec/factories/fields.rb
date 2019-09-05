FactoryBot.define do
    factory :field, class: Fields::ShortText do
        config do 
        {title: "first_name",
        format: "text"}
        end
    end
end
