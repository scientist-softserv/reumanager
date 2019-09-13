class RecommenderForm < ApplicationRecord
  attr_accessor :add_field

  has_many :sections, autosave: true, dependent: :destroy

  enum status: {
    draft: 0,
    active: 1
  }

  validates :name, presence: true

  accepts_nested_attributes_for :sections, allow_destroy: true

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
