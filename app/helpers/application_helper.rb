module ApplicationHelper
  def errors_for(object, message = nil)
    html = ''
    unless object.errors.blank?
      html << "<div id='error_explanation' class='alert-danger' onclick='$(this).slideUp();'>\n"
      html << if message.blank? && object.new_record?
                "\t\t<h2>There was a problem creating the #{object.class.name.humanize.downcase}</h2>\n"
              elsif message.blank?
                "\t\t<h2>There was a problem updating the #{object.class.name.humanize.downcase}</h2>\n"
              else
                "<h2>#{message}</h2>"
              end
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html.html_safe
  end

  def format_date(date, alt_text)
    date&.strftime('%A, %B %-d') || alt_text
  end

  def format_date_string(date_string)
    return unless date_string.present?
    Date.parse(date_string)&.strftime('%m/%d/%Y')
  end

  def app_title
    Setting[:app_title] || 'REU Program'
  end
end
