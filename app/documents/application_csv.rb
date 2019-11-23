require 'csv'

class ApplicationCsv
  attr_accessor :applications

  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(applications)
    @applications = applications
  end

  def headers
    @headers ||= ApplicationForm.first.csv_column_headers
  end

  def build
    CSV.generate(headers: true) do |csv|
      csv << headers
      applications.each do |application|
        row = RowBuilder.new(headers)
        data = application.data_flattened
        data.each { |k, v| row.add k, format_value_for_csv(v[:value], 'application', application.id, v[:path]) }
        csv << row.raw_values
      end
    end
  end

  def format_value_for_csv(value, model, model_id, access_path)
    if value =~ /^data:/
      url_helpers.download_url(model, model_id, access_path, format: :pdf, subdomain: @application.user.subdomain)
    else
      value
    end
  end

  class RowBuilder
    attr_reader :headers, :row

    def initialize(headers)
      @headers = headers
      @row = headers.each_with_object({}) { |header, hash| hash[header] = nil }
    end

    def add(header, value)
      @row[header] = value.to_s
    end

    def values
      @row.values.map do |str|
        # remove spaces from around '/'
        str&.gsub(/ \/| \/ |\/ /, '/')
      end
    end

    def raw_values
      @row.values
    end
  end
end
