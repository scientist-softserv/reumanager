require 'rails_helper'

RSpec.describe Recommendation do
  subject(:recommendation) { FactoryBot.build(:recommendation) }

  describe 'validating data' do
    let(:recommender_form) do
      rf = FactoryBot.build(:recommender_form)
      rf.recommendation_section.fields.each do |field|
        field.required = true
        field.min_length = 3
      end
      rf.save
      rf
    end
    before(:each) do
      allow(recommendation).to receive(:current_recommender_form).and_return(recommender_form)
    end

    it 'returns errors for invalid data' do
      recommendation.data = {
        'recommender_form' => recommender_form.recommendation_section.fields.each_with_object({}) do |field, hash|
          hash[field.title_key] = ''
        end
      }
      binding.pry
    end

    it 'returns not errors for valid data' do

    end
  end
end
