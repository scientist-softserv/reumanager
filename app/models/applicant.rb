class Applicant < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :lockable, :timeoutable, :confirmable

  belongs_to :applicant_datum, dependent: :destroy, autosave: true
  has_many :recommenders, dependent: :destroy

  delegate :data,
           :data=,
           :recommender_info,
           :recommender_info=,
           to: :applicant_datum

  enum state: {
    'Started' => 'started',
    'Submitted' => 'submitted',
    'Completed' => 'completed',
    'Withdrawn' => 'withdrawn',
    'Accepted' => 'accepted',
    'Rejected' => 'rejected'
  }

  before_validation :setup_data

  def data=(new_value)
    setup_data
    self.applicant_datum.data = new_value
  end

  def data_flattened
    data.each_with_object({}) do |(_, value), hash|
      if value.is_a?(Array)
        value.each_with_index do |v, i|
          hash.merge!(v.transform_keys { |k| k + (i + 1).to_s })
        end
      else
        hash.merge!(value)
      end
    end
  end

  private

  def setup_data
    self.applicant_datum = ApplicantDatum.new if self.applicant_datum.blank?
  end
end
