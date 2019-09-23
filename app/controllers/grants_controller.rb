class GrantsController < ApplicationController
  before_action :authenticate_user!, except: %i[new_program create_program new_billing create_billing]
  before_action :set_grant, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  layout "user"

  def index
    @grants = Grant.all
  end

  def show
    Apartment::Tenant.switch(@grant.subdomain) do
      @admins = ProgramAdmin.all
    end
  end

  def new
    @grant = Grant.new
  end

  def edit
  end

  def create
    @grant = Grant.new(grant_params)
    if @grant.save
      redirect_to reu_program_settings_path(subdomain: @grant.subdomain), notice: 'Your program was successfully created.'
    else
      render :new
    end
  end

  def update
    if @grant.update(grant_params)
      redirect_to @grant, notice: 'Grant was successfully updated.'
    else
      render :edit
    end
  end

  def new_program
    @grant = Grant.new
    render layout: 'marketing'
  end

  def create_program
    @grant = Grant.new(initial_grant_params)
    if @grant.save
      redirect_to reu_program_dashboard_url(subdomain: @grant.subdomain), notice: 'Your program was successfully created.'
    else
      render :new
    end
  end

  def new_billing
    render layout: 'admin'
  end

  def create_billing
    redirect_to ''
  end

  def destroy
    @grant.destroy
    redirect_to grants_path, notice: 'Grant was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grant
    @grant = Grant.find(params[:id])
  end

  def amount
    @amount ||= 75000
  end

  # Only allow a trusted parameter "white list" through.
  def grant_params
    params.require(:grant).permit(:program_title, :subdomain, :coupon_code)
  end

  def initial_grant_params
    params.require(:grant).permit(:program_title, :subdomain, :coupon_code, :admin_first_name, :admin_last_name, :admin_password, :admin_password_confirmation, :admin_email)
  end

end
