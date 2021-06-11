require 'csv'

class ApplicationCsv
  attr_accessor :applications, :selected_fields
  attr_reader :fields, :recommender_fields

  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(applications, selected_fields = {})
    @applications = applications
    @selected_fields = selected_fields
    @fields = []
    @recommender_fields = []
    build_fields_mapping
  end

  def current_application_form
    @current_application_form ||= ApplicationForm.includes(sections: :fields).where(status: :active).first
  end

  def sections
    @sections ||= Section.active
  end

  def build_fields_mapping
    selected_fields.each do |section_id, field_ids|
      section = sections.find { |s| s.id.to_s == section_id }
      section.fields.where(id: field_ids).map do |field|
        if section.recommender?
          @recommender_fields << [section.title_key, field.title_key]
        elsif section.repeating?
          section.count.times do |index|
            @fields << [section.title_key, index, field.title_key]
          end
        else
          @fields << [section.title_key, field.title_key]
        end
      end
    end
  end

  def headers
    @headers ||=
      [
        ['sign_up_email'],
        field_headers,
        recommender_field_headers
      ].flatten
  end

  def field_headers
    fields.map do |path|
      if path.count == 3
        "#{path.first}_#{path.second + 1}_#{path.third}"
      else
        path.join('_')
      end
    end
  end

  def recommender_field_headers
    header_sets =
      Array.new(recommender_section.count) do |index|
        recommender_fields.map do |path|
          "#{path.first}_#{index + 1}_#{path.last}"
        end
      end
    header_sets.flatten
  end

  def build
    CSV.generate(headers: true) do |csv|
      csv << headers
      applications.map do |application|
        csv << build_row(application)
      end
    end
  end

  def recommender_section
    RecommenderForm.active.recommender_section
  end

  def recommender_section_title_key
    @recommender_section_title_key ||= recommeder_section.title_key
  end

  def build_row(application)
    [
      [application.user.email],
      map_fields_to_data(application),
      map_recommender_fields_to_data(application)
    ].flatten
  end

  def map_fields_to_data(application)
    fields.map do |path|
      format_value_for_csv(
        application.data.dig(*path),
        application.id,
        path.join('--'),
        application.user.subdomain
      )
    end
  end

  def map_recommender_fields_to_data(application)
    Array.new(recommender_section.count) do |index|
      recommender_fields.map do |path|
        full_path = path.dup.insert(1, index)
        format_value_for_csv(
          application.recommender_info.dig(*full_path),
          application.id,
          full_path.join('--'),
          application.user.subdomain
        )
      end
    end
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
