class RecommendationsController < ApplicationController
  before_action :redirect_withdrawn_users
  before_action :load_status_from_token

  def show_recommendations
    @form = RecommenderForm.includes(sections: :fields).where(status: :active).first
  end

  def update_recommendations
    @recommendation.data = params.require(:data).permit!
    if @recommendation.valid?
      @recommendation.submitted_at = Time.current
      @recommendation.save(validate: false)
      Notification.recommendation_thanks(@recommendation, @application).deliver
      render json: { success: true, message: 'Thank you for submitting your recommendation' }
    else
      @recommendation.save(validate: false)
      render json: {
        success: false,
        message: 'Please address these issues',
        errors: @recommendation.errors.full_messages
      }
    end
  end

  private

  def redirect_withdrawn_users
    redirect_to status_path if current_application&.withdrawn?
  end

  def load_status_from_token
    raise ActionController::RoutingError, 'Not Found' if params[:token].blank?
    @recommendation = Recommendation.find_by_token(params[:token])
    raise ActionController::RoutingError, 'Not Found' if @recommendation.blank?
    @application = @recommendation.application
  end

  class NoEmailError < StandardError; end
end
