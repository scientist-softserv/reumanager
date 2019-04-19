module ReuProgram
  class AdminController < ApplicationController
    before_action :authenticate_program_admin!
    layout 'admin'

    protected

    def authenticate_program_admin!
      if program_admin_signed_in?
        super
      else
        redirect_to new_program_admin_session_path
      end
    end

    def after_sign_in_path_for(resource)
      reu_program_dashboard_path
    end
  end
end
