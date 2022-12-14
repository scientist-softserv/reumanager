class RecommenderForm < ApplicationRecord
  attr_accessor :add_field

  has_many :sections, autosave: true, dependent: :destroy

  enum status: {
    draft: 0,
    active: 1
  }

  validates :name, presence: true

  accepts_nested_attributes_for :sections, allow_destroy: true

  after_save do
    self.sections.update_all(count: self.recommenders_count) if self.recommenders_count_previously_changed?
  end

  scope :active, -> { where(status: :active).first }

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

  def validate_data(data)
    error_messages = []
    sections = self.sections.to_a
    data.each do |title_key, values|
      section = sections.find { |s| s.title_key == title_key }
      error_messages.concat(section.validate_data(values))
    end
    error_messages
  end

  def recommender_section
    @recommender_section ||= self.sections.where("title = 'Recommenders Form' OR important='recommender'").first
  end

  def recommendation_section
    @recommendation_section ||=
      self.sections.find do |section|
        section.title == 'Recommendation Form' || section.important == 'recommendation'
      end
  end

  def json_schema(section: 'recommender')
    JSON.generate(build_json_schema(section: section))
  end

  def pretty_json_schema(section: 'recommender')
    JSON.pretty_generate(build_json_schema(section: section))
  end

  def build_json_schema(section: 'recommender')
    section = sections.find { |s| Regexp.new(section).match?(s.important.downcase) }
    { sections: [section.to_form] }
  end

  def ui_schema(section: 'recommender')
    JSON.generate(build_ui_schema(section: section))
  end

  def pretty_ui_schema(section: 'recommender')
    JSON.pretty_generate(build_ui_schema(section: section))
  end

  def build_ui_schema(section: 'recommender')
    section = sections.find { |s| Regexp.new(section).match?(s.important.downcase) }
    section.build_ui_schema
  end

  def validations
    sections.each_with_object({}) do |section, hash|
      hash[section.title_key] = section.validations
    end
  end
end
