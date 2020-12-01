class Notification < ActionMailer::Base
  default from: 'info@reumanager.co',
    reply_to: (Setting['Mail From'].present? ? Setting['Mail From'] : 'test@test.com'),
    content_type: 'text/plain'

  def recommendation_request(recommendation, application)
    @applicant_first_name = application.field_value('profile', 'first_name').strip
    @applicant_last_name = application.field_value('profile', 'last_name').strip
    @recommender_first_name = application.recommender(recommendation.email).first_name.strip
    @recommender_last_name = application.recommender(recommendation.email).last_name.strip
    @url = "https://#{Apartment::Tenant.current}.#{Rails.configuration.action_mailer[:default_url_options][:host]}/recommendations?token=#{recommendation.token}"
    subject = if recommendation.last_sent_at.present?
                "REU follow-up recommendation request for #{@applicant_first_name}"
              else
                "REU recommendation request for #{@applicant_first_name}"
              end

    mail(to: recommendation.email, subject: subject)
  end

  # thank you to recommender once recommendation is received.
  def recommendation_thanks(recommendation, application)
    @applicant_first_name = application.field_value('profile', 'first_name').strip
    @applicant_last_name = application.field_value('profile', 'last_name').strip
    @recommender_first_name = application.recommender(recommendation.email).first_name.strip
    @recommender_last_name = application.recommender(recommendation.email).last_name.strip
    mail(to: recommendation.email, subject: "REU recommendation received for #{@applicant_first_name}")
  end
end
