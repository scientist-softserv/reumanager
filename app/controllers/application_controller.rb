class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  helper_method :expired?
  helper_method :started?
  helper_method :subdomain?
  helper_method :current_grant
  helper_method :current_application

  rescue_from Apartment::TenantNotFound, with: :tenant_not_found

  after_action :set_csrf_cookie

  def set_csrf_cookie
    cookies["X-CSRF-Token"] = form_authenticity_token
  end

  def expired?
    if Setting[:application_deadline].present?
      Time.now > Setting[:application_deadline]
    else
      false
    end
  end

  def started?
    if Setting[:application_start].present?
      Time.now > Setting[:application_start]
    else
      false
    end
  end

  def check_deadline
    redirect_to closed_url if expired?
  end

  def subdomain?
    request.subdomain.present? && %w[www web].exclude?(request.subdomain)
  end

  def current_application
    return if current_user.blank?
    current_user.application
  end

  def current_grant
    return @grant if @grant.present?
    if subdomain?
      @grant = Grant.where(subdomain: request.subdomain).first
      raise Apartment::TenantNotFound if @grant.blank?
    end
    @grant
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def tenant_not_found
    redirect_to root_path
  end

  def after_sign_in_path_for(resource)
    if resource.has_role?(:super)
      grants_path
    elsif resource.has_role?(:admin)
      reu_program_dashboard_path
    else
      root_path
    end
  end

end
