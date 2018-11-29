class AcademicRecord < ActiveRecord::Base

  RESEARCH_INTERESTS = [
    'interest 1',
    'interest 2',
    'interest 3',
    'interest 4',
    'interest 5',
    'interest 6',
    'interest 7',
    'interest 8',
    'interest 9',
  ]

  attr_accessible :academic_level, :cpu_skills, :degree, :finish, :gpa, :gpa_comment, :gpa_range, :leadership_experience, :programming_experience, :research_experience, :research_interest_1, :research_interest_2, :research_interest_3, :start, :university, :major, :minor
  belongs_to :applicant, :class_name => "Applicant", :foreign_key => "applicant_id"
  attr_accessible :transcript
  has_attached_file :transcript, :url => ":rails_relative_url_root/system/:class/:attachment/:id_partition/:style/:filename"
  validates_attachment :transcript, :presence => true,
    content_type: { content_type: ['application/pdf','image/jpg', 'image/jpeg', 'image/gif', 'image/png'] },
    :size => { :in => 0..10.megabytes }

  validates :finish, presence: true
  validates :gpa, presence: true
  validates :gpa_range, presence: true
  validates :leadership_experience, presence: true
  validates :major, presence: true
  validates :programming_experience, presence: true
  validates :research_experience, presence: true
  validates :research_interest_1, presence: true
  validates :start, presence: true
  validates :university, presence: true

  def to_s
    record = "#{self.start.strftime("%Y.%m")} - #{self.finish.strftime("%Y.%m")} studying #{self.degree} at #{self.university}"
    record << "\n#{Markdown.render "GPA Comment: " + self.gpa_comment}" if self.gpa_comment
    record
  end

end
