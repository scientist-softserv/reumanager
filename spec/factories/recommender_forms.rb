FactoryBot.define do
  factory :recommender_form, class: RecommenderForm do
    name { 'test recommender form' }
    status { :draft }

    sections do
      [
        build(:section, fields_count: 4, title: 'Recommenders Form'),
        build(:section, fields_count: 5, title: 'Recommendation Form')
      ]
    end
  end
end
