class Section < ApplicationRecord
  attr_accessor :add_field

  belongs_to :application_form
  has_many :fields, dependent: :destroy

  accepts_nested_attributes_for :fields, allow_destroy: true

  def handle_add_field
    return if Question::TYPES.values.exclude?(add_field)
    max_order_number = self.fields.to_a.map(&:order).max
    self.fields << add_field.constantize.new(order: (max_order_number || 0) + 1)
  end
end
