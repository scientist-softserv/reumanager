require 'csv'

class ApplicantCsv
  attr_accessor :applicants
  
  def initialize(applicants)
    @applicants = applicants
  end

  def build
    applicant_attributes = applicants.first.data_flattened.keys
    attributes = %w{ id email } 
    attributes.concat(applicant_attributes)
    CSV.generate(headers: true ) do |csv|
      csv << attributes
        
      applicants.each do |applicant|
        csv << [applicant.id, applicant.email].concat(applicant.data_flattened.values)
      end   
    end
  end

end
