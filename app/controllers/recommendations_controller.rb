class RecommendationsController < ApplicationController
  before_action :load_status_from_token, only: %i[show_recommendations update_recommendations]

  def show_recommendations
    @form = RecommenderForm.includes(sections: :fields).where(status: :active).first
  end

  def update_recommendations
    @status.data = params.require(:data).permit!
    if @status.valid?
      @status.submitted_at = Time.current
      @status.save(validate: false)
      Notification.recommendation_thanks(@status, @application).deliver
      render json: { success: true, message: 'Thank you for submitting your recommendation'}
    else
      @status.save(validate: false)
      render json: {
        success: false,
        message: 'Please address these issues',
        errors: @status.errors.full_messages
      }
    end
  end

  def resend
    # get the id of the recommender_status from params and fetch it from the database
    @recommender_status = RecommenderStatus.find(params[:id])
    @application = @recommender_status.application
    Notification.recommendation_request(@recommender_status, @application).deliver
    @recommender_status.last_sent_at = Time.current
    @recommender_status.save
    redirect_to status_path
  end

  private

  def load_status_from_token
    raise ActionController::RoutingError, 'Not Found' if params[:token].blank?
    @status = RecommenderStatus.find_by_token(params[:token])
    raise ActionController::RoutingError, 'Not Found' if @status.blank?
    @application = @status.application
  end

  class NoEmailError < StandardError; end
end
