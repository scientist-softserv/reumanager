class ApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_withdrawn_users, except: %i[status withdraw restart]
  before_action :setup_application

  def show_application
    @form = ApplicationForm.includes(sections: :fields).where(status: :active).first
    @data = current_application&.data.blank? ? @form.default_data : current_application&.data
  end

  def update_application
    current_user.application.update_data(params.require(:data).permit!)
    if current_user.application.save
      render json: {
        success: true,
        message: 'Successfully saved your information. Please review your information on the status page or provide information about your recommenders on the recommenders page.'
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
    if current_application.can_withdraw?
      current_application.withdraw
      current_application.save
      flash[:notice] = 'Your application has now been withdrawn. You will need to restart and complete your application to be considered.'
    else
      flash[:alert] = 'You cannot withdraw your application'
    end

    redirect_to status_path
  end

  def restart
    if current_application.can_restart?
      current_application.restart
      current_application.save
      flash[:notice] = 'Your application has now been restarted.'
    else
      flash[:alert] = 'Unable to restart your application at this time.'
    end
    redirect_to status_path
  end

  private

  def redirect_withdrawn_users
    redirect_to status_path if current_application&.withdrawn?
  end
end
