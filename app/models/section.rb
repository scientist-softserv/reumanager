class Section < ApplicationRecord
  attr_accessor :add_question

  belongs_to :application_form
  has_many :questions

  accepts_nested_attributes_for :questions, allow_destroy: true

  def handle_add_question
    return if Question::TYPES.values.exclude?(add_question)
    max_order_number = self.questions.to_a.map(&:order).max
    self.questions << add_question.constantize.new(order: (max_order_number || 0) + 1)
  end
end
