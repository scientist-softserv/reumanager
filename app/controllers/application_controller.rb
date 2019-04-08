class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  include ApplicationHelper
  before_action :log_x_forwarded_by
  before_action :check_user_subdomain_combo
  helper_method :expired?
  helper_method :is_subdomain?
  helper_method :settings_filled_in?
  rescue_from Apartment::TenantNotFound, with: :tenant_not_found
  before_action :set_cache_buster

  protected

  def settings_filled_in?
    Setting[:application_start].present? && Setting[:program_start_date].present?
  end

  # used to prevent seeing user info through history after sign-out.
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def check_deadline
    redirect_to closed_url if expired?
  end

  def log_x_forwarded_by
    if request.env["HTTP_X_FORWARDED_FOR"].nil?
      Rails.logger.info "NO HTTP_X_FORWARDED_FOR"
    else
      Rails.logger.info "REMOTE IP: " + request.env["HTTP_X_FORWARDED_FOR"].split(',').first
    end
  end

  def set_state
    current_applicant.set_state
  end

  def is_subdomain?
    request.subdomain.present? && %w[www web].exclude?(request.subdomain)
  end

  def current_grant
    return @grant if @grant.present?
    if is_subdomain?
      @grant = Grant.where(subdomain: request.subdomain).first
      raise Apartment::TenantNotFound if @grant.blank?
    end
    @grant
  end

  def tenant_not_found
    redirect_to root
  end

  def check_user_subdomain_combo
    # if current_user and current subdomain
    if current_user.present? && is_subdomain?
      # and user is a member of the grant for that subdomain
      if current_grant.users.include?(current_user)
        true
      else
        render plain: '403 Forbidden', status: 403
      end
    else
      true
    end
  end

end
