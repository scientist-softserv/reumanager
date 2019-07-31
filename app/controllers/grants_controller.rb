class GrantsController < ApplicationController
  before_action :set_grant, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  layout "user"

  # GET /grants
  def index
    @grants = Grant.all
  end

  # GET /grants/1
  def show
  end

  # GET /grants/new
  def new
    @grant = Grant.new
  end

  # GET /grants/1/edit
  def edit
  end

  # POST /grants
  def create
    @grant = Grant.new(grant_params)
    @user = User.new(params[:grant][:users])
    @user.is_super_admin = true 
    @user.save
    @grant.users << User.last

    if @grant.valid?
      # customer = Stripe::Customer.create(
      #   :email => params[:email],
      #   :source  => params[:stripeToken]
      # )

      # coupon_amount = (@grant.coupon_code.upcase == "EXISTING" ? 20000 : 0)

      # charge = Stripe::Charge.create(

      #   :customer    => customer.id,
      #   :amount      => amount - coupon_amount,
      #   :description => 'Rails Stripe customer',
      #   :currency    => 'usd'
      # )

      @grant.save
      sign_in(@grant.users.first)
      # redirect_to new_grant_setting_path(grant_id: @grant.id), notice: 'Your program was successfully created.'
      redirect_to settings_url(subdomain: @grant.subdomain), notice: 'Your program was successfully created.'
    else
      render :new
    end


    # rescue Stripe::CardError => e
    # flash[:error] = e.message
    # redirect_to new_grants_url

  end

  # PATCH/PUT /grants/1
  def update
    if @grant.update(grant_params)
      redirect_to @grant, notice: 'Grant was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /grants/1
  def destroy
    @grant.destroy
    redirect_to grants_url, notice: 'Grant was successfully destroyed.'
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
      params.require(:grant).permit(:program_title, :institution, :subdomain, :contact_email, :contact_password, :coupon_code, :users_attributes => [:id, :email, :password])
    end
end
