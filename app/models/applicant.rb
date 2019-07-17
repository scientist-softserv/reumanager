class Applicant < ApplicationRecord
  
  require 'csv'

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
  
  def self.to_csv
    attributes = %w{ id submitted_at }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |applicant|
        csv << attributes.map{ |attr| applicant.send(attr) }
      end
    end
  end
  
  def name
    "#{first_name} #{last_name}"
  end
  
end
