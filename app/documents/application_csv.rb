require 'csv'

class ApplicationCsv
  attr_accessor :applications, :selected_fields

  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(applications, selected_fields = {})
    @applications = applications
    @selected_fields = selected_fields
  end

  def current_application_form
    @current_application_form ||= ApplicationForm.includes(sections: :fields).where(status: :active).first
  end

  def fields
    return @fields if @fields.present?

    @fields ||=
      selected_fields.each_with_object([]) do |(section_id, field_ids), array|
        section = current_application_form.sections.find_by_id(section_id)
        section.fields.where(id: field_ids).map do |field|
          if section.repeating?
            section.count.times do |index|
              array << [section.title_key, index, field.title_key]
            end
          else
            array << [section.title_key, field.title_key]
          end
        end
      end
  end

  def headers
    @headers ||=
      ['sign_up_email'].concat(
        fields.map do |path|
          if path.count == 3
            "#{path.first}_#{path.second + 1}_#{path.third}"
          else
            path.join('_')
          end
        end
      )
  end

  def build
    CSV.generate(headers: true) do |csv|
      csv << headers
      applications.map do |application|
        csv << build_row(application)
      end
    end
  end

  def build_row(application)
    [application.user.email].concat(
      fields.map do |path|
        format_value_for_csv(
          application.data.dig(*path),
          application.id,
          path.join('--'),
          application.user.subdomain
        )
      end
    )
  end

  def format_value_for_csv(value, model_id, access_path, subdomain)
    if value =~ /^data:/
      url_helpers.download_url(
        'application',
        model_id,
        access_path.tr('.', ''),
        format: :pdf,
        subdomain: subdomain
      )
    else
      value
    end
  end
end
