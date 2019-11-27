class Interest < ActiveRecord::Base
    RESEARCH_INTERESTS = [
      'Peter Jenniskens',
      'Kathryn Bywaters',
      'Pascal Lee',
      'Janice Bishop',
      'Ann Marie Cody and Doug Caldwell',
      'Cristina Dalle Ore',
      'Chloe Beddingfield',
      'Alex Pollak and Andrew Siemion',
      'David Summers',
      'Friedemann Freund',
      'Virginia Gulick',
      'Matthew Tiscareno'
  ]

  attr_accessible :cpu_skills, :statement, :facing_challenges_experience, :leadership_experience, :research_experience, :research_interest_1, :research_interest_2, :research_interest_3
  belongs_to :applicant

  validates :statement, presence: true
  validates :facing_challenges_experience, presence: true
  validates :leadership_experience, presence: true
  validates :research_experience, presence: true
  validates :research_interest_1, presence: true

  def to_s
    "Interests for #{self.applicant.name}"
  end

end
