module ReuProgram
  class InvoicesController < AdminController
    before_action :load_invoice, only: %i[show edit update]

    def show; end

    def new
      @invoice = Invoice.new
    end

    def create
      @invoice = Invoice.new(invoice_params)
      @invoice.grant = current_grant
      if @invoice.save
        flash[:success] = "Successfully updated Invoice information"
        redirect_to reu_program_invoice_path(@invoice)
      else
        render 'new'
      end
    end

    def edit; end

    def update
      if @invoice.update(invoice_params)
        flash[:success] = "Successfully updated Invoice information"
        redirect_to reu_program_invoice_path(@invoice)
      else
        render 'new'
      end
    end

    private

    def load_invoice
      @invoice = Invoice.find(params[:id])
    end

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
