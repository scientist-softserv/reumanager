class Section < ApplicationRecord
  belongs_to :application_form, optional: true
  belongs_to :recommender_form, optional: true
  has_many :fields, -> { order(:order) }, dependent: :destroy, autosave: true

  validates :title, uniqueness: { scope: :application_form_id }, if: :application_form_id?
  validates :title, uniqueness: { scope: :recommender_form_id }, if: :recommender_form_id?
  validates :count, inclusion: { in: [1, 2, 3], message: 'must be greater than 0 and less than 4' }

  accepts_nested_attributes_for :fields, allow_destroy: true

  def important_fields
    fields.where.not(important: nil)
  end

  def title_key
    title.downcase.tr(' ', '_')
  end

  def dependant_json_config
    fields.select(&:dependant?).each_with_object({}) do |field, hash|
      hash.merge!(field.dependancy_config)
    end
  end

  def fields_json_config
    fields.reject(&:dependant?).each_with_object({}) do |field, hash|
      hash.merge!(field.json_config)
    end
  end

  def required_fields
    fields.each_with_object([]) do |field, array|
      array << field.title_key if field.required
    end
  end

  def build_json_schema
    {
      title: title,
      type: :object,
      required: required_fields,
      properties: fields_json_config,
      dependencies: dependant_json_config
    }.reject { |_k, v| v.blank? }
  end

  def to_form
    {
      schema: build_json_schema,
      ui: build_ui_schema,
      isRepeating: repeating?,
      count: count,
      title: title,
      singular: title.singularize,
      key: title_key,
      id: id
    }
  end

  def build_ui_schema
    fields.each_with_object({}) do |field, hash|
      hash.merge!(field.ui_config)
    end
  end
end
