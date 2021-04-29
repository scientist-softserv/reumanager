require 'csv'

class ApplicationCsv
  attr_accessor :applications, :selected_fields

  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(applications, selected_fields)
    @applications = applications
    @selected_fields = selected_fields
  end

  def all_headers
    @all_headers ||= ApplicationForm.first.csv_column_headers
  end

  def headers
    @headers ||= ApplicationForm.first.csv_column_headers(selected_fields)
  end

  def build
    CSV.generate(headers: true) do |csv|
      csv << headers
      rows = build_rows
      rows.each do |row|
        csv << row.raw_values.reject(&:blank?)
      end
    end
  end

  def build_rows
    applications.map do |application|
      row = RowBuilder.new(all_headers)
      data = application.data_flattened(selected_fields)
      data.each do |k, v|
        row.add(
          k,
          format_value_for_csv(v[:value], 'application', application.id, v[:path], application.user.subdomain)
        )
      end
      row
    end
  end

  def format_value_for_csv(value, model, model_id, access_path, subdomain)
    if value =~ /^data:/
      url_helpers.download_url(model, model_id, access_path.tr('.', ''), format: :pdf, subdomain: subdomain)
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
