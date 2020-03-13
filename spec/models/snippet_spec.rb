require 'rails_helper'

RSpec.describe Snippet, type: :model do
  describe 'class methods' do
    it 'looks up snippet by name using []' do
      FactoryBot.create(:snippet, :with_short_value)
      expect(Snippet['Test General Discription']).to eq('this is a short description')
      expect(Snippet['test_general_discription']).to eq('this is a short description')
    end

    it 'returns all configured snippets' do
      snippet = FactoryBot.create(:snippet)
      expect(Snippet.all_setup?).to be false
      snippet.update(value: 'aksjdfklajsd')
      expect(Snippet.all_setup?).to be true
    end
  end

  describe 'display methods' do
    it 'displays its name in a human friendly manner' do
      snippet = FactoryBot.build(:snippet, name: 'cool_snippet')
      expect(snippet.display_name).to eq('Cool Snippet')
    end
  end
end
