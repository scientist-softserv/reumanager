class ApplicationForm < ApplicationRecord
  has_many :sections, dependent: :destroy

  enum status: {
    draft: 0,
    active: 1
  }

  validates :name, presence: true

  accepts_nested_attributes_for :sections, allow_destroy: true

  before_save do
    self.important_paths = self.set_important_paths
  end

  def set_important_paths
    important_sections.each_with_object({}) do |s, hash|
      hash[s.title_key] = s.important_fields.map(&:title_key)
    end
  end

  def important_sections
    sections.where.not(important: nil)
  end

  def json_schema
    JSON.generate(build_json_schema)
  end

  def pretty_json_schema
    JSON.pretty_generate(build_json_schema)
  end

  def build_json_schema
    {
      title: name,
      type: :object,
      properties: sections.each_with_object({}) do |s, h|
        h.merge!(s.build_json_schema)
      end
    }
  end

  def ui_schema
    JSON.generate(build_ui_schema)
  end

  def pretty_ui_schema
    JSON.pretty_generate(build_ui_schema)
  end

  def build_ui_schema
    sections.each_with_object({}) do |section, hash|
      hash.merge!(section.build_ui_schema)
    end
  end
end
