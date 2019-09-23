class WelcomeController < ApplicationController
  after_action :handle_subdomain, except: %i[index thanks]
  layout 'marketing', except: %i[index thanks]

  def index
    unless subdomain?
      render :marketing_index, layout: "marketing"
    end
  end

  def tours; end

  def pricing; end

  def demo
    redirect_to subdomain: 'demo', controller: 'welcome', action: 'index'
  end

  def support
    redirect_to ('https://github.com/notch8/reumanager')
  end

  def thanks
  end

  private

  def handle_subdomain
    raise ActionController::RoutingError.new('Not Found') if subdomain?
  end
end


