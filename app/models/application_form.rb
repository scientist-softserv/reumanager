class ApplicationForm < ApplicationRecord
  has_many :sections, dependent: :destroy

  enum status: {
    draft: 0,
    active: 0
  }

  validates :name, presence: true
end
