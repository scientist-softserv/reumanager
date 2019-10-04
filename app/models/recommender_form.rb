class RecommenderForm < ApplicationRecord
  attr_accessor :add_field

  has_many :sections, autosave: true, dependent: :destroy

  enum status: {
    draft: 0,
    active: 1
  }

  validates :name, presence: true

  accepts_nested_attributes_for :sections, allow_destroy: true

  def duplicate
    new_form = self.dup
    new_form.name = "#{new_form.name} Copy"
    new_form.status = :draft
    new_form.save
    self.sections.each do |section|
      new_section = section.dup
      new_section.recommender_form = new_form
      new_section.save
      section.fields.each do |field|
        new_field = field.dup
        new_field.section = new_section
        new_field.save
      end
    end
    new_form.reload
    new_form
  end

  def json_schema(section: 'recommender')
    JSON.generate(build_json_schema(section: section))
  end

  def pretty_json_schema(section: 'recommender')
    JSON.pretty_generate(build_json_schema(section: section))
  end

  def build_json_schema(section: 'recommender')
    section = sections.detect { |s| Regexp.new(section).match?(s.title.downcase) }
    { sections: [section.to_form] }
  end

  def ui_schema(section: 'recommender')
    JSON.generate(build_ui_schema(section: section))
  end

  def pretty_ui_schema(section: 'recommender')
    JSON.pretty_generate(build_ui_schema(section: section))
  end

  def build_ui_schema(section: 'recommender')
    section = sections.detect { |s| Regexp.new(section).match?(s.title.downcase) }
    section.build_ui_schema
  end
end
