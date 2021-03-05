class SupportController < ApplicationController

    def send_support_email

        if (params[:subject].blank?) || (params[:first_name].blank?) || (params[:last_name].blank?) || (params[:email].blank?) || (params[:message].blank?)
            redirect_to support_path(params.to_unsafe_h)
            flash[:alert] = "Your message was not sent because there was information missing in your submission. Please fill in all required fields before pressing send."
        else
            @support_email = SupportMailer.support_email(params)
            @support_email.deliver
            redirect_to support_path
            flash[:notice] = "Message Sent!"
        end
    end

private
    def send_support_email_params
        params.require(:subject, :first_name, :last_name, :email, :message).permit(:phone, :program_name)
    end
  end
