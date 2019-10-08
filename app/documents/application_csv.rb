require 'csv'

class ApplicationCsv
  attr_accessor :applications

  def initialize(applications)
    @applications = applications
  end

  def build
    application_attributes = applications.first.data_flattened.keys
    attributes = %w{ id email }
    attributes.concat(application_attributes)
    CSV.generate(headers: true ) do |csv|
      csv << attributes

      applications.each do |application|
        csv << [application.id, application.user.email].concat(application.data_flattened.values)
      end
    end
  end

end
