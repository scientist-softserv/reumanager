class RecommenderFormsController < ApplicationController
  before_action :authenticate_user!
  before_action :setup_application

  def show_recommenders
    @form = RecommenderForm.includes(sections: :fields).where(status: :active).first
  end

  def update_recommenders
    current_user.application.recommender_info = params.require(:data).permit!
    if current_user.application.save
      render json: { success: true, message: 'Successfully saved the form' }
    else
      render json: {
        success: false,
        message: 'There are errors in the form',
        errors: current_user.application.errors.full_messages
      }
    end
  rescue ActionController::ParameterMissing
    render json: {}
  end
end
