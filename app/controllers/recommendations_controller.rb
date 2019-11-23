class RecommendationsController < ApplicationController
  before_action :redirect_withdrawn_users
  before_action :load_status_from_token

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

  private

  def redirect_withdrawn_users
    redirect_to status_path if current_application&.withdrawn?
  end

  def load_status_from_token
    raise ActionController::RoutingError, 'Not Found' if params[:token].blank?
    @status = RecommenderStatus.find_by_token(params[:token])
    raise ActionController::RoutingError, 'Not Found' if @status.blank?
    @application = @status.application
  end

  class NoEmailError < StandardError; end
end
