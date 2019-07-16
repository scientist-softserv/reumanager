class WelcomeController < ApplicationController
  def index
    redirect_to "/info" if !is_subdomain?
  end

  def thanks
  end
end
