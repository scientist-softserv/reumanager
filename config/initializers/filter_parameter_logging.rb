# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  password
  password_confirmation
  phone
  dob
  citizenship
  disability
  ethnicity
  race
  address2
  city
  country
  zip
  gpa
  gpa_range
]
