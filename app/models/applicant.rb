class Applicant < ApplicationRecord

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :lockable, :timeoutable, :confirmable

  belongs_to :applicant_datum
  alias_attribute :data, :applicant_datum

  enum state: {
    'Started' => 'started',
    'Submitted' => 'submitted',
    'Completed' => 'completed',
    'Withdrawn' => 'withdrawn',
    'Accepted' => 'accepted',
    'Rejected' => 'rejected'
  }

  after_initialize do
    self.applicant_datum = ApplicantDatum.new if self.applicant_datum.blank?
  end
end
