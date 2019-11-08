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
