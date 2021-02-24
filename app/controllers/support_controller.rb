class SupportController < ApplicationController

    # def send_support_email
    #    @support_email = SupportMailer.support_email(params[:subject], params[:first_name], params[:last_name], params[:email], params[:phone], params[:program_name], params[:message])
    #    @support_email.deliver
    #     if @support_email[:subject].blank?
    #         redirect_to support_path
    #         flash[:alert] = "Please fill in all required fields"
    #     else
    #         redirect_to support_path
    #         flash[:notice] = "Message Sent"
    #   end
    # end

    def send_support_email
        
        @support_email = SupportMailer.support_email(params[:subject], params[:first_name], params[:last_name], params[:email], params[:phone], params[:program_name], params[:message])

        @support_email.deliver
        if (params[:subject] == "") || (params[:first_name] == "") || (params[:last_name] == "") || (params[:email] == "") || (params[:phone] == "") || (params[:message] == "")
            redirect_to support_path
            flash[:alert] = "Please fill in all required fields"
        else
            redirect_to support_path
            flash[:notice] = "Message Sent"
        end
    end

    # def cant_send_email?
    #     @support_email[:subject].blank?
    # end

private
    def send_support_email_params
        params.require(:subject, :first_name, :last_name, :email, :phone, :message).permit(:program_name)
    end
  end
