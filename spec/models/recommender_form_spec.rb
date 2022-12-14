require 'rails_helper'

RSpec.describe RecommenderForm do
  it 'can duplicate itself' do
    rf = FactoryBot.create(:recommender_form)
    rf_dup = rf.duplicate
    expect(rf_dup.name).to eq("#{rf.name} Copy")
    expect(rf_dup.status).to eq('draft')
    expect(rf_dup.sections.count).to eq(rf_dup.sections.count)
    # expect the duplicate to have the same attributes but be in a draft state and have a changed name
  end

  it 'can generate a accurate json schema' do
    # test json_schema method
  end

  it 'can generate a ui schema' do
    # test ui_schema method
  end

  it ' can build a hash of validations' do
    # test validations method
  end
end
