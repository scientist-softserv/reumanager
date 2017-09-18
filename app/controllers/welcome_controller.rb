class WelcomeController < ApplicationController
  def index
    if !is_subdomain?
      redirect_to "/info"
    end
  end

  def thanks
  end
end
