class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true, with: :reset_session

  helper_method :expired?,
                :started?,
                :subdomain?,
                :admin_user?,
                :super_user?,
                :super_admin_user?,
                :current_grant,
                :current_application,
                :handle_recommendations?

  rescue_from Apartment::TenantNotFound, with: :tenant_not_found

  before_action :set_raven_context
  before_action :authenticate_for_staging
  after_action :set_csrf_cookie

  def authenticate_for_staging
    return unless %w[staging].include?(Rails.env)
    authenticate_or_request_with_http_basic do |username, password|
      username == 'reuadmin' && password == 'reutesting123'
    end
  end

  def admin_user?
    current_user.has_role?(:admin)
  end

  def super_user?
    current_user.has_role?(:super)
  end

  def super_admin_user?
    current_user.has_role?(:super) || current_user.has_role?(:super_admin)
  end

  def set_csrf_cookie
    cookies['X-CSRF-Token'] = form_authenticity_token
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
    raise ActionController::RoutingError, 'Not Found'
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
      if resource.application.blank? || resource.application.started?
        application_path
      else
        status_path
      end
    end
  end

  def setup_application
    not_found if current_user.blank?
    if current_user.application.blank?
      app = Application.new
      app.save(validate: false) # this really needs to exist
      current_user.application = app
      current_user.save
    end
    @application = current_user.application
  end

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def handle_error_json_return(exception)
    Raven.capture_exception(exception)

    err = { message: exception.message, success: false }

    if Rails.env.development? && exception.is_a?(Exception)
      err[:backtrace] = exception.backtrace.select do |line|
        # filter out non-significant lines:
        %w[/gems/ /rubygems/ /lib/ruby/].all? do |litter|
          !line.include?(litter)
        end
      end
    end

    render json: err, status: 500
  end

  def handle_recommendations?
    @handle_recommendations ||= RecommenderForm.active.handle_recommendations?
  end
end
