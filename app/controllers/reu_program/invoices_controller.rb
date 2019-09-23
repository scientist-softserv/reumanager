module ReuProgram
  class InvoicesController < ApplicationController
    def new
      @invoice = Invoice.new
    end

    def create
      @invoice = Invoice.new(invoice_params)
      @invoice.grant = current_grant
      if @invoice.save
        #flash[:success] = "Success."
        redirect_to reu_program_dashboard_path
      else
        render 'new'
      end
    end

    def show
      @invoice = Invoice.find(params[:id])
    end

    private

    def invoice_params
      params.require(:invoice).permit(:university_or_institution,
        :department,
        :program_title,
        :contact_name,
        :email,
        :phone,
        :billing_name,
        :billing_address,
        :billing_email,
        :billing_phone,
        :po_number)
      end
    end
  end
