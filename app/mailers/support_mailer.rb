class SupportMailer < ActionMailer::Base
    default from: "info@reumanager.co",
        content_type: 'text/plain'
    
    def support_email(params)
        @subject = params[:subject]
        @first_name = params[:first_name]
        @last_name = params[:last_name]
        @email = params[:email]
        @phone = params[:phone]
        @program_name = params[:program_name]
        @message = params[:message]
        mail(to: 'support@notch8.com', subject: params[:subject])
    end
end