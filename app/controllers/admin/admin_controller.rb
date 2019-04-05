module Admin
  class AdminController < ApplicationController
    before_action :authenticate_program_admin!
    layout 'admin'
  end
end
