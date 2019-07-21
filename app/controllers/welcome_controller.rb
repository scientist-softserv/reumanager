class WelcomeController < ApplicationController
  def index
    redirect_to '/info' unless subdomain?
  end

  def thanks; end
end
