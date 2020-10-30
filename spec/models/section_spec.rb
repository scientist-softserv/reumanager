require 'rails_helper'

RSpec.describe Section, type: :model do
  subject { FactoryBot.create :section }

  it '#important_fields' do
    subject.fields.first.update(important: 'test')
    expect(subject.important_fields.count).to eq(1)
  end

  it '#title_key' do
    expect(subject.title_key).to eq('profile')
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

  it '#build_ui_schema' do
  end

  it '#dependant_fields' do
  end

  it '#required_fields' do
  end

  it '#build_ui_schema' do
  end

  it '#validations' do
  end

  it '#csv_column_headers' do
  end
end
