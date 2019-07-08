class ApplicationForm < ApplicationRecord
  has_many :sections, dependent: :destroy

  enum status: {
    draft: 0,
    active: 0
  }

  validates :name, presence: true

  accepts_nested_attributes_for :sections, allow_destroy: true

  after_create do
    self.sections.create(title: 'Profile')
    Questions::ShortText.create(section: self.sections.first)
  end
end
