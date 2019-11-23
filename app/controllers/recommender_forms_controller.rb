class RecommenderFormsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_withdrawn_users
  before_action :setup_application

  def show_recommenders
    @form = RecommenderForm.includes(sections: :fields).where(status: :active).first
  end

  def update_recommenders
    current_user.application.recommender_info = params.require(:data).permit!
    if current_user.application.save
      current_user.application.update_recommender_status
      current_user.application.recommender_statuses.each do |status|
        next if status.last_sent_at.present?
        status.update(last_sent_at: Time.current)
        Notification.recommendation_request(status, current_user.application).deliver
      end
      render json: { success: true, message: 'Successfully saved the form' }
    else
      current_user.application.save(validate: false)
      render json: {
        success: false,
        message: 'There are errors in the form',
        errors: current_user.application.errors.full_messages
      }
    end
  end

  def resend
    @recommender_status = RecommenderStatus.find(params[:id])
    @application = @recommender_status.application
    if can_send_email?
      Notification.recommendation_request(@recommender_status, @application).deliver
      @recommender_status.last_sent_at = Time.current
      @recommender_status.save
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

  def can_send_email?
    @recommender_status.last_sent_at.blank? ||
      @recommender_status.last_sent_at.present? &&
      (@recommender_status.last_sent_at + 1.day) > Time.current
  end
end
