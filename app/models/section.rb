class Section < ApplicationRecord
  belongs_to :application_form, optional: true
  belongs_to :recommender_form, optional: true
  has_many :fields, -> { order(:order, :created_at) }, dependent: :destroy, autosave: true

  validates :title, uniqueness: { scope: :application_form_id }, if: :application_form_id?
  validates :title, uniqueness: { scope: :recommender_form_id }, if: :recommender_form_id?
  validates :count, inclusion: { in: [1, 2, 3], message: 'must be greater than 0 and less than 4' }

  accepts_nested_attributes_for :fields, allow_destroy: true

  def self.active
    left_outer_joins(:application_form, :recommender_form)
      .where('application_forms.status = 1 OR recommender_forms.status = 1')
  end

  def important_fields
    fields.where.not(important: nil)
  end

  def title_key
    title.downcase.tr(' ', '_')
  end

  def recommender?
    important == 'recommender'
  end

  def validate_data(data)
    error_messages = []
    if data.is_a?(Array)
      data.each_with_index do |set, index|
        self.fields.each do |field|
          errors = field.validate_data(set.fetch(field.title_key, nil), index)
          error_messages.concat(errors)
        end
      end
    else
      self.fields.each do |field|
        errors = field.validate_data(data.fetch(field.title_key, nil))
        error_messages.concat(errors)
      end
    end
    error_messages
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

  def build_json_schema
    {
      title: title,
      type: :object,
      description: description,
      properties: json_config,
      dependencies: dependant_fields
    }.reject { |_k, v| v.blank? }
  end

  def validations
    fields.each_with_object({}) do |field, hash|
      hash[field.title_key] = {}
      if field.required
        hash[field.title_key][:required] = { message: "#{field.title} is required" }
      end
      if field.respond_to?(:min_length) && field.min_length.present?
        hash[field.title_key][:min_length] = {
          min: field.min_length.to_i,
          message: "#{field.title} must contain more than #{field.min_length} characters"
        }
      end
      next unless field.respond_to?(:max_length) && field.max_length.present?
      hash[field.title_key][:max_length] = {
        max: field.max_length.to_i,
        message: "#{field.title} must contain less than #{field.max_length} characters"
      }
    end
  end

  def to_form
    {
      schema: build_json_schema,
      ui: build_ui_schema,
      isRepeating: repeating?,
      validations: validations,
      count: count,
      description: description,
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

  def csv_column_headers(selected_fields = nil)
    field_names = if selected_fields.nil?
                    self.fields.map(&:title_key)
                  else
                    self.fields.map(&:title_key).select { |field| selected_fields[field] == '1' }
                  end
    if !repeating?
      field_names
    else
      headers = []
      count.times do |i|
        headers.concat(field_names.map { |n| "#{n}_#{i + 1}" })
      end
      headers
    end
  end
end
