class ApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_withdrawn_users
  before_action :setup_application

  def show_application
    @form = ApplicationForm.includes(sections: :fields).where(status: :active).first
  end

  def update_application
    current_user.application.data = params.require(:data).permit!
    if current_user.application.save
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

  def status
    current_user.application ||= Application.new
    current_application
  end

  def submit
    if current_application.can_submit?
      current_application.submit
      current_application.save
      flash[:notice] = 'Your application has been submitted'
    else
      flash[:alert] = 'Your application can not be at this time submitted'
    end
    redirect_back fallback_location: status_path
  end

  def withdraw
    unless current_application.withdrawn?
      current_application.withdraw
      current_application.save
    end
    flash[:notice] = 'Your application has now been withdrawn. You will need to restart and complete your application to be considered.'
    redirect_back fallback_location: status_path
  end

  def restart
    unless current_application.started?
      current_application.restart
      current_application.save
    end
    flash[:notice] = 'Your application has now been restarted.'
    redirect_back fallback_location: status_path
  end

  private

  def redirect_withdrawn_users
    redirect_to status_path if current_application&.withdrawn?
  end
end
