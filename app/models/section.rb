class Section < ApplicationRecord
  belongs_to :application_form
  has_many :questions
end
