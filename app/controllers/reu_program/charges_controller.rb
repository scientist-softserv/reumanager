module ReuProgram
  class ChargesController < AdminController
    before_action :set_amount

    def new; end

    def create
      customer = Stripe::Customer.create(
        email: params[:stripeEmail],
        source: params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: @amount,
        description: 'Rails Stripe customer',
        currency: 'usd'
      )

      current_grant.credit_card_charged_at = Time.current
      current_grant.save

      if charge.save
        flash[:notice] = 'Thank you! The charge was successful'
        redirect_to reu_program_dashboard_path
      else
        flash[:alert] = 'There was an error please contact support'
        redirect_back fallback_location: new_reu_program_charge_path
      end
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end

    private

    def set_amount
      # Amount in cents
      @amount = 35_000
    end
  end
end
