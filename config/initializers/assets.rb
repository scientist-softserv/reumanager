if Rails.env.development?
  ActiveRecord::Base.logger = Logger.new('/dev/null')
end