require 'rails_helper'

RSpec.describe Field do
  describe 'validating data' do
    describe 'validating required status' do
      subject(:field) { FactoryBot.build(:field) }

      it '#required_applies?' do
        expect(field.required_applies?).to be_falsy
        field.required = true
        expect(field.required_applies?).to be_truthy
      end

      it '#validate_required' do
        field.required = true
        expect(field.validate_required('')).to eq("#{field.title} is required")
        expect(field.validate_required('thing')).to be_nil
      end

      it '#validate_data' do
        field.required = true
        msg = "#{field.title} is required"
        expect(field.validate_data('')).to contain_exactly(msg)
        expect(field.validate_data('thing')).to_not include(msg)
      end
    end

    describe 'validating min length' do
      subject(:field) { FactoryBot.build(:field) }

      it '#min_length_applies?' do
        expect(field.min_length_applies?).to be_falsy
        field.min_length = 3
        expect(field.min_length_applies?).to be_truthy
      end

      it '#validate_min_length' do
        field.min_length = 3
        expect(field.validate_min_length('sd')).to eq("#{field.title} must be at least 3 characters long")
        expect(field.validate_min_length('asdg')).to be_nil
      end

      it '#validate_data' do
        field.min_length = 3
        msg = "#{field.title} must be at least 3 characters long"
        expect(field.validate_data('s')).to contain_exactly(msg)
        expect(field.validate_data('thing')).to_not include(msg)
      end
    end

    describe 'validating max length' do
      subject(:field) { FactoryBot.build(:long_text_field) }

      it '#max_length_applies?' do
        expect(field.max_length_applies?).to be_falsy
        field.max_length = 10
        expect(field.max_length_applies?).to be_truthy
      end

      it '#validate_max_length' do
        field.max_length = 5
        expect(field.validate_max_length('qwerty')).to eq("#{field.title} cannot use more than 5 characters")
        expect(field.validate_max_length('qwe')).to be nil
      end

      it '#validate_data' do
        field.max_length = 5
        msg = "#{field.title} cannot use more than 5 characters"
        expect(field.validate_data('qwerty')).to contain_exactly(msg)
        expect(field.validate_data('qwe')).to_not include(msg)
      end
    end
  end
end
