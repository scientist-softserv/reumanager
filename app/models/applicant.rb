class Applicant < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :lockable,
         :confirmable
  # :timeoutable,

  belongs_to :applicant_datum, foreign_key: :applicant_datum_id, dependent: :destroy, autosave: true
  has_many :recommenders, dependent: :destroy

  delegate :recommender_info,
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

  def data
    setup_data
    self.applicant_datum.data
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

  def field_value(*args)
    self.data.dig(*args)
  end

  private

  def setup_data
    return if self.applicant_datum_id.present?
    self.applicant_datum = ApplicantDatum.new
  end
end
