class WelcomeController < ApplicationController
  def index
    if !is_subdomain?
      redirect_to "/info"
    elsif !settings_filled_in?
      if current_user
        redirect_to settings_path
      else
        redirect_to new_user_session_path
      end
    end
  end

  def thanks
  end
end
