class ApplicationForm < ApplicationRecord
  has_many :sections, -> { order(:order, :created_at) }, dependent: :destroy

  enum status: {
    draft: 0,
    active: 1
  }

  validates :name, presence: true

  accepts_nested_attributes_for :sections, allow_destroy: true

  before_save do
    self.important_paths = self.set_important_paths
  end

  def duplicate
    new_form = self.dup
    new_form.name = "#{new_form.name} Copy"
    new_form.status = :draft
    new_form.save
    self.sections.each do |section|
      new_section = section.dup
      new_section.application_form = new_form
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
      sections: sections.map(&:to_form)
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

  def validations
    sections.each_with_object({}) do |section, hash|
      hash[section.title_key] = section.validations
    end
  end
end
