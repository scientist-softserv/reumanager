module ReuProgram
  class DashboardController < AdminController
    def index
      @sum = Application.count
      @count = Application.group('state').count
    end
  end
end
