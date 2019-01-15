class Notification < ActionMailer::Base
  default from:  Setting[:mail_from]
  default content_type: "text/plain"

  def application_submitted(applicant)
   @applicant = applicant
   mail(:to => applicant.email, :subject => "REU application received for #{applicant.name}")
  end

  def recommendation_request(recommendation)
    @recommendation = recommendation
    @url = applicants_recommendations_edit_url(token: recommendation.token)
    @url_display = @url.gsub(/https+:\/\//, "")
    mail(:to => recommendation.recommender.email, :subject => "REU recommendation request for #{recommendation.applicant.name}")
  end

  def recommendation_follow_up_request(recommendation)
    @recommendation = recommendation
    @url = applicants_recommendations_edit_url(token: recommendation.token)
    @url_display = @url.gsub(/https+:\/\//, "")
    mail(:to => recommendation.recommender.email, :subject => "REU follow-up recommendation request for #{recommendation.applicant.name}")
  end

  # thank you to recommender once recommendation is received.
  def recommendation_thanks(recommendation)
    @recommendation = recommendation
    mail(:to => recommendation.recommender.email, :subject => "REU recommendation received for #{recommendation.applicant.name}")
  end

  def application_complete(applicant)
    @applicant = applicant
    mail(:to => applicant.email, :subject => "REU application complete for #{applicant.name}")
  end

end
