class Interest < ActiveRecord::Base
    RESEARCH_INTERESTS = [
    'Pascal Lee',
    'Ann Marie Cody',
    'Uma Gorti',
    'Virginia Gulick',
    'Peter Jenniskens',
    'Friedemann Freund',
    'David Summers',
    'Franck Marchis',
    'Kathryn Bywater',
    'Andrew Siemion',
    'Matthew Tiscareno',
  ]

  attr_accessible :cpu_skills, :leadership_experience, :programming_experience,:research_experience, :research_interest_1, :research_interest_2, :research_interest_3
  belongs_to :applicant

  validates :leadership_experience, presence: true
  validates :programming_experience, presence: true
  validates :research_experience, presence: true
  validates :research_interest_1, presence: true

  def to_s
    "Interests for #{self.applicant.name}"
  end

end
