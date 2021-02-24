class SupportMailer < ActionMailer::Base
    default from: "info@reumanager.co",
        content_type: 'text/plain'
    
    def support_email(subject, first_name, last_name, email, phone, program_name, message)
        @subject = subject
        @first_name = first_name
        @last_name = last_name
        @email = email
        @phone = phone
        @program_name = program_name
        @message = message
        mail(to: 'support@notch8.com', subject: subject)
    end
end