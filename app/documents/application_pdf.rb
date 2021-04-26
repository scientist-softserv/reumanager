class ApplicationPdf
  include FormDisplayHelper
  include Prawn::View
  attr_accessor :applications, :application

  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(applications)
    @applications = applications
    font_families.update(
      'DejaVuSans' => {
        normal: 'app/assets/fonts/DejaVuSans.ttf',
        bold: 'app/assets/fonts/DejaVuSans-Bold.ttf'
      }
    )
  end

  def build
    applications.each do |application|
      @application = application
      print_application(application)
      start_new_page
      print_recommendations(application)
      start_new_page
    end
  end

  def print_application(application)
    text 'Application Information', size: 22, inline_format: true, style: :bold
    application.data.each do |key, value|
      section 10 do
        text format_key(key), size: 18, inline_format: true, style: :bold
        move_down 1
        section 10 do
          case value
          when Array
            value.each_with_index do |item, index|
              item.each do |k, v|
                path = "#{key}--#{index}--#{k}"
                text "<b>#{format_key(k)}:</b> #{format_value_for_pdf(v, 'application', application.id, path)}", inline_format: true
              end
            end
          when Hash
            value.each do |k, v|
              path = "#{key}--#{k}"
              text "<b>#{format_key(k)}:</b> #{format_value_for_pdf(v, 'application', application.id, path)}", inline_format: true
            end
          end
        end
      end
    end
  end

  def print_recommendations(application)
    text 'Recommenders', size: 18, inline_format: true, style: :bold
    info = application.recommender_info.fetch('recommenders_form', {})
    if info.empty?
      text 'User has not entered their recommenders information', inline_format: true
    else
      info.each_with_index do |r, index|
        recommendation = application.recommendations.detect { |s| s.email == r['email'] }
        color = if recommendation&.submitted_at.present?
                  '28a745' # bootstrap success
                elsif recommendation&.last_sent_at.blank?
                  'ffc107' # bootstrap warning
                else
                  '343a40' # bootstrap dark
                end
        span 400 do
          section 10 do
            section 10 do
              text 'Recommender', size: 14, inline_format: true, style: :bold
              if recommendation.present?
                pad 5 do
                  indent 10 do
                    message = recommendation.submitted_at.present? ? 'Recommender submitted a recommendation.' : 'Recommender has not yet submitted a recommendation.'
                    text message, color: color
                  end
                end
              end
              r.each do |k, v|
                path = "recommenders_form--#{index}--#{k}"
                text "<b>#{format_key(k)}:</b> #{format_value_for_pdf(v, 'recommender', @application.id, path)}", inline_format: true
              end
              if recommendation.present?
                move_down 10
                text "Recommender's Response", size: 14, inline_format: true, style: :bold
                move_down 5
                recommendation.data.fetch('recommendation_form', {}).each do |k, v|
                  path = "recommendation_form--#{k}"
                  text "<b>#{format_key(k)}:</b> #{format_value_for_pdf(v, 'recommendation', recommendation.id, path)}", inline_format: true
                end
              end
            end
          end
        end
      end
    end
  end

  def section(value)
    pad value do
      indent value do
        yield if block_given?
      end
    end
  end

  def format_value_for_pdf(value, model, model_id, access_path)
    if value =~ /^data:/
      url = url_helpers.download_url(model, model_id, access_path, format: :pdf, subdomain: @application.user.subdomain)
      "<u><link href='#{url}'>Download\<\/link><\/u>"
    else
      value
    end
  end
end
