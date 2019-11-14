class ApplicationsController < ApplicationController
  before_action :authenticate_user!, except: %i[show_recommendations update_recommendations]
  before_action :setup_application, except: %i[show_recommendations update_recommendations]
  before_action :load_status_from_token, only: %i[show_recommendations update_recommendations]

  def show_application
    @form = ApplicationForm.includes(sections: :fields).where(status: :active).first
  end

  def update_application
    current_user.application.data = params.require(:data).permit!
    Rails.logger.info "\napplication is valid?  #{current_user.application.valid?}\n"
    if current_user.application.valid? && current_user.application.save
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

  def status
    current_user.application ||= Application.new
    current_application
  end
end
