class Section < ApplicationRecord
  attr_accessor :add_field

  belongs_to :application_form
  has_many :fields, dependent: :destroy

  validates :title, uniqueness: { scope: :application_form_id }

  accepts_nested_attributes_for :fields, allow_destroy: true

  def handle_add_field
    return if Field::TYPES.values.exclude?(add_field)
    Rails.logger.info("\n\n   field #{add_field}")
    order = (self.fields.to_a.map(&:order).max || 0) + 1
    Rails.logger.info("\n\n   order #{order}")
    klass = add_field.constantize
    Rails.logger.info(klass.name)
    field = klass.new(order: order)
    self.fields << field
  end
end
