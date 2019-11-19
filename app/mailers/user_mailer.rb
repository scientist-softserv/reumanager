class UserMailer < DeviseMailer
  include Devise::Controllers::UrlHelpers
  default template_path: 'users/mailer'
end
