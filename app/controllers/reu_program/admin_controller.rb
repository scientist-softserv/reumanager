module ReuProgram
  class AdminController < ApplicationController
    before_action :authenticate_user!
    before_action :only_admins!
    layout 'admin'

    private

    def user_super_or_admin?
      current_user.has_role?(:admin) || current_user.has_role?(:super)
    end

    def only_admins!
      raise ActionController::RoutingError.new('Not Found') unless user_super_or_admin?
    end
  end
end
