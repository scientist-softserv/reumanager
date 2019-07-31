class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  # before_action :log_x_forwarded_by
  helper_method :expired?
  helper_method :started?
  helper_method :subdomain?
  helper_method :settings_filled_in?
  rescue_from Apartment::TenantNotFound, with: :tenant_not_found
  # before_action :set_cache_buster
  after_action :set_csrf_cookie

  helper_method :current_grant


  def set_csrf_cookie
    cookies["X-CSRF-Token"] = form_authenticity_token
  end

  def settings_filled_in?
    # Setting[:application_start].present? && Setting[:program_start_date].present?
    true
  end

  def expired?
    if Setting[:application_deadline].present?
      expire_at = Time.parse("#{Setting[:application_deadline]} 23:59:59 PST")
      Time.now > expire_at
    else
      false
    end
  end

  def started?
    if Setting[:application_start].present?
      start_at = Time.parse("#{Setting[:application_start]} 00:00:00 PST")
      Time.now > start_at
    else
      false
    end
  end

  # used to prevent seeing user info through history after sign-out.
  def set_cache_buster
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  def check_deadline
    redirect_to closed_url if expired?
  end

  def log_x_forwarded_by
    if request.env['HTTP_X_FORWARDED_FOR'].nil?
      Rails.logger.info 'NO HTTP_X_FORWARDED_FOR'
    else
      Rails.logger.info "REMOTE IP: #{request.env['HTTP_X_FORWARDED_FOR'].split(',').first}"
    end
  end

  def set_state
    current_applicant.set_state
  end

  def subdomain?
    request.subdomain.present? && %w[www web].exclude?(request.subdomain)
  end

  def current_grant
    return @grant if @grant.present?
    if subdomain?
      @grant = Grant.where(subdomain: request.subdomain).first
      raise Apartment::TenantNotFound if @grant.blank?
    end
    @grant
  end

  def tenant_not_found
    redirect_to root
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Applicant)
      application_path
    elsif resource.is_a?(User)
      grants_path
    else
      super
    end
  end
end
