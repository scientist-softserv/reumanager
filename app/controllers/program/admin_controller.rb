module Program
  class AdminController < ApplicationController
    before_action :authenticate_program_admin!
    layout 'admin'

    protected

    def authenticate_program_admin!
      if user_signed_in?
        super
      else
        redirect_to new_program_admin_session_path
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end
  end
end
