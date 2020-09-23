require 'rails_helper'

RSpec.describe Setting, type: :model do
  describe 'class methods' do
    it 'looks up setting by name using []' do
      FactoryBot.create(:setting, :with_value)
      expect(Setting['App Title Test']).to eq('This is the test app title')
      expect(Setting['app_title_test']).to eq('This is the test app title')
    end

    it 'returns all configured settings' do
      setting = FactoryBot.create(:setting)
      expect(Setting.all_setup?).to_not be
      setting.update(value: 'aksjdfklajsd')
      expect(Setting.all_setup?).to be
    end
  end

  describe 'display methods' do
    it 'displays its name in a human friendly manner' do
      setting = FactoryBot.build(:setting, name: 'cool_setting')
      expect(setting.display_name).to eq('Cool Setting')
    end
  end
end
