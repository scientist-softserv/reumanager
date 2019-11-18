class Section < ApplicationRecord
  belongs_to :application_form, optional: true
  belongs_to :recommender_form, optional: true
  has_many :fields, -> { order(:order, :created_at) }, dependent: :destroy, autosave: true

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

  def json_config
    fields.each_with_object({}) do |field, hash|
      hash.merge!(field.json_config)
    end
  end

  def dependant_fields
    fields.each_with_object({}) do |field, hash|
      hash.merge!(field.dependacies_config) if field.respond_to?(:dependacies_config)
    end
  end

  def required_fields
    fields.map do |field|
      next unless field.required
      field.title_key
    end.compact
  end

  def build_json_schema
    {
      title: title,
      type: :object,
      required: required_fields,
      properties: json_config,
      dependencies: dependant_fields
    }.reject { |_k, v| v.blank? }
  end

  def validations
    fields.each_with_object({}) do |field, hash|
      hash[field.title_key] = {}
      if field.required
        hash[field.title_key].merge!(required: { message: "#{field.title} is required" })
      end
      if field.respond_to?(:max_length) && field.max_length.present?
        hash[field.title_key].merge!(
          max_length: {
            max: field.max_length.to_i,
            message: "#{field.title} is must contain less than #{field.max_length} characters"
          }
        )
      end
    end
  end

  def to_form
    {
      schema: build_json_schema,
      ui: build_ui_schema,
      isRepeating: repeating?,
      validations: validations,
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
