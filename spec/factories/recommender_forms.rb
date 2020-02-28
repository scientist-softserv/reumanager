FactoryBot.define do
  factory :recommender_form, class: RecommenderForm do
    name { 'test recommender form'}
    status { :draft }

    sections do
      [
        create(:section, title: 'Recommenders Form'),
        create(:section, title: 'Recommendation Form')
      ]
    end
  end
end
