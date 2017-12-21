require 'spec_helper'

describe Setting do

  describe 'self.[]' do
    before(:each) { Setting.create!(name: 'App Title', value: 'this is only a test') unless Setting.find_by_name('app_title') }

    it 'returns the value for the given setting name' do
      expect(Setting['App Title']).to be_a_kind_of(String)
      expect(Setting['App Title']).to eq("this is only a test")
    end

    it 'accepts a string or symbol for the name value' do
      expect(Setting['App Title']).to be_a_kind_of(String)
      expect(Setting['App Title']).to eq("this is only a test")

      expect(Setting[:app_title]).to be_a_kind_of(String)
      expect(Setting[:app_title]).to eq("this is only a test")
    end

  end

end
