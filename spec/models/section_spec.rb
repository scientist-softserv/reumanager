require 'rails_helper'

RSpec.describe Section, type: :model do
  subject(:section) { FactoryBot.create :section }

  it '#important_fields' do
    section.fields.first.update(important: 'test')
    expect(section.important_fields.count).to eq(1)
  end

  it '#title_key' do
    expect(section.title_key).to eq('profile')
  end

  it '#json_config' do
    section = Section.new(
      title: 'profiles',
      fields: [Fields::ShortText.new(title: 'First Name')]
    )
    expect(section.json_config).to eq(
      'first_name' => { format: :text, title: 'First Name', type: :string }
    )
  end

  describe 'Validating data' do
    let(:fields) do
      [
        FactoryBot.build(:field, required: true),
        FactoryBot.build(:field, min_length: 3),
        FactoryBot.build(:long_text_field, max_length: 5)
      ]
    end
    subject(:section) do
      section = FactoryBot.create(:section)
      section.fields = fields
      section
    end

    it 'returns error messages for invalid data' do
      error_messages = section.validate_data(
        fields.first.title_key => '',
        fields.second.title_key => '23',
        fields.third.title_key => 'qwerty'
      )
      expect(error_messages).to contain_exactly(
        "#{fields.first.title} is required",
        "#{fields.second.title} must be at least 3 characters long",
        "#{fields.third.title_key} cannot use more than 5 characters"
      )
    end

    it 'returns no error_messages for valid data' do
      error_messages = section.validate_data(
        fields.first.title_key => 'something',
        fields.second.title_key => '12345',
        fields.third.title_key => 'qwer'
      )

      expect(error_messages.empty?).to be_truthy
    end
  end

  it '#dependant_fields' do
  end

  it '#required_fields' do
  end

  it '#build_ui_schema' do
    field1 = FactoryBot.build(:file_field)
    field2 = FactoryBot.build(:long_text_field)
    section.fields = [field1, field2]
    ui_schema = section.build_ui_schema
    expect(ui_schema.to_json).to eq("{\"#{field1.title_key}\":{\"ui:options\":{\"accept\":\".pdf\"}},\"#{field2.title_key}\":{\"ui:widget\":\"textarea\"}}")
  end

  it '#validations' do
    field1 = FactoryBot.build(:field, required: true, min_length: 3)
    field2 = FactoryBot.build(:long_text_field, max_length: 10)
    section.fields = [field1, field2]
    validations = section.validations
    expect(validations[field1.title_key].keys).to contain_exactly(:required, :min_length)
    expect(validations[field2.title_key].keys).to contain_exactly(:max_length)

    expect(validations[field1.title_key][:required][:message]).to eq("#{field1.title} is required")
    expect(validations[field1.title_key][:min_length][:min]).to eq(3)
    expect(validations[field1.title_key][:min_length][:message]).to eq("#{field1.title} must contain more than 3 characters")
    expect(validations[field2.title_key][:max_length][:max]).to eq(10)
    expect(validations[field2.title_key][:max_length][:message]).to eq("#{field2.title} must contain less than 10 characters")
  end

  it '#csv_column_headers' do
  end
end
