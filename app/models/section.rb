class Section < ApplicationRecord
  attr_reader :add_question

  belongs_to :application_form
  has_many :questions

  accepts_nested_attributes_for :questions, allow_destroy: true

  def add_question=(new_value)
    return if Question::TYPES.values.exclude?(new_value)
    self.questions << new_value.constantize.new
  end
end
