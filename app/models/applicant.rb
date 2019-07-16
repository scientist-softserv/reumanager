class Applicant < ApplicationRecord

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :lockable, :timeoutable, :confirmable

  belongs_to :applicant_datum

  delegate :data, to: :applicant_datum

  enum state: {
    'Started' => 'started',
    'Submitted' => 'submitted',
    'Completed' => 'completed',
    'Withdrawn' => 'withdrawn',
    'Accepted' => 'accepted',
    'Rejected' => 'rejected'
  }

  def data=(new_value)
    self.applicant_datum = ApplicantDatum.new if self.applicant_datum.blank?
    self.applicant_datum.data = new_value
  end
end
