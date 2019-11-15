class Notification < ActionMailer::Base
  default from: Setting['Mail From'].present? ? Setting['Mail From'] : 'test@test.com'
  default content_type: 'text/plain'

  def recommendation_request(recommender_status, application)
    @applicant_first_name = application.field_value('profile', 'first_name').strip
    @applicant_last_name = application.field_value('profile', 'last_name').strip
    @recommender_first_name = application.recommender(recommender_status.email).first_name.strip
    @recommender_last_name = application.recommender(recommender_status.email).last_name.strip
    @url = "https://#{Apartment::Tenant.current}.#{Rails.configuration.action_mailer[:default_url_options][:host]}/recommendations?token=#{recommender_status.token}"
    subject = if recommender_status.last_sent_at.present?
                "REU follow-up recommendation request for #{@applicant_first_name}"
              else
                "REU recommendation request for #{@applicant_first_name}"
              end

    mail(to: recommender_status.email, subject: subject)
  end

  # thank you to recommender once recommendation is received.
  def recommendation_thanks(recommender_status, application)
    @applicant_first_name = application.field_value('profile', 'first_name').strip
    @applicant_last_name = application.field_value('profile', 'last_name').strip
    @recommender_first_name = application.recommender(recommender_status.email).first_name.strip
    @recommender_last_name = application.recommender(recommender_status.email).last_name.strip
    mail(to: recommender_status.email, subject: "REU recommendation received for #{@applicant_first_name}")
  end
end
