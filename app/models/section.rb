class Section < ApplicationRecord
  attr_accessor :add_field

  belongs_to :application_form
  has_many :fields, -> { order(:order) }, dependent: :destroy

  validates :title, uniqueness: { scope: :application_form_id }

  accepts_nested_attributes_for :fields, allow_destroy: true

  def handle_add_field
    return if Field::TYPES.values.exclude?(add_field)
    order = (self.fields.to_a.map(&:order).max || 0) + 1
    klass = add_field.constantize
    field = klass.new(order: order)
    self.fields << field
  end

  def title_key
    title.downcase.tr(' ', '_')
  end

  def fields_json_config
    fields.each_with_object({}) do |field, hash|
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
      title_key => {
        title: title,
        type: :object,
        required: required_fields,
        properties: fields_json_config
      }
    }
  end

  def build_ui_schema
    fields.each_with_object({}) do |field, hash|
      hash.merge!(field.ui_config)
    end
  end
end
