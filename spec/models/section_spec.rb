require 'rails_helper'

RSpec.describe Section, type: :model do
  subject {FactoryBot.create :section}

  it "#important_fields" do
    section = FactoryBot.create :section, important: nil
    expect(section.important).to be_nil
  end

  it "#handle_add_field returns nil if not getting any data from Field::TYPES" do
    expect(subject.handle_add_field(field: )).to be_nil
  end

  it "#title_key" do
    expect(subject.title_key).to eq("this_is_a_profile")
  end

  it "#fields_json_config" do
    expect(subject.fields_json_config).to eq({"First Name"=>{:type=>:string, :format=>"text"}})
  end

  it "method #build_json_schema returns nested data if nested is set to true" do
    expect(subject.build_json_schema(nested: true)).to eq({"profile"=>{:title=>"profile", :type=>:object, :properties=>{"First Name"=>{:type=>:string, :format=>"text"}}}})
  end

  it "method #build_json_schema returns non-nested if nested is set to false" do
    expect(subject.build_json_schema(nested: false)).to eq({:properties=>{"First Name"=>{:format=>"text", :type=>:string}}, :type=>:object})
  end

  it "#unnested_schema" do
    expect(subject.unnested_schema).to eq({:type=>:object, :properties=>{"First Name"=>{:type=>:string, :format=>"text"}}})
  end

  it "#repeating_schema" do
    expect(subject.repeating_schema).to eq({"profile"=>{:title=>"profile", :type=>:array, :items=>{:type=>:object, :properties=>{"First Name"=>{:type=>:string, :format=>"text"}}}}})
  end

  it "#non_repeating_schema" do
    expect(subject.non_repeating_schema).to eq({"profile"=>{:title=>"profile", :type=>:object, :properties=>{"First Name"=>{:type=>:string, :format=>"text"}}}})
  end

  it "#required_fields" do
    expect(subject.required_fields).to be_empty
  end

  it "#build_ui_schema" do
    expect(subject.build_ui_schema).to be_empty
  end

end
