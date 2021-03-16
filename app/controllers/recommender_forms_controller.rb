class RecommenderFormsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_withdrawn_users
  before_action :redirect_completed_users
  before_action :setup_application

  def show_recommenders
    @form = RecommenderForm.includes(sections: :fields).where(status: :active).first
  end

  def update_recommenders
    current_user.application.recommender_info = params.require(:data).permit!
    if current_user.application.save
      current_user.application.update_recommendation
      current_user.application.recommendations.each do |recommendation|
        next if recommendation.last_sent_at.present?
        recommendation.update_columns(last_sent_at: Time.current)
      end
      render json: {
        success: true,
        message: 'Successfully saved your recommenders information. You can have the system ask for their recommendation via email from the status page.'
      }
    else
      current_user.application.save(validate: false)
      render json: {
        success: false,
        message: 'There are errors in the form',
        errors: current_user.application.errors.full_messages
      }
    end
  rescue StandardError => e
    handle_error_json_return(e)
  end

  def resend
    @recommendation = Recommendation.find(params[:id])
    @application = @recommendation.application
    if can_send_email?
      Notification.recommendation_request(@recommendation, @application).deliver if current_user.application.profile_exists?
      @recommendation.last_sent_at = Time.current
      @recommendation.save
      flash[:notice] = 'Resent email to recommender'
    else
      flash[:alert] = 'Unable to resend email to this recommender at this time'
    end
    redirect_to status_path
  end

  private

  def redirect_withdrawn_users
    redirect_to status_path if current_application&.withdrawn?
  end

  def redirect_completed_users
    redirect_to status_path if current_application&.completed? ||
                               current_application&.accepted? ||
                               current_application&.rejected?
  end

  def can_send_email?
    return false unless current_user.application.profile_exists?

    @recommendation.last_sent_at.blank? ||
      @recommendation.last_sent_at.present? &&
        (@recommendation.last_sent_at + 1.day) < Time.current
  end
end
