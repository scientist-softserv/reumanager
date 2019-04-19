module ReuProgram
  class ApplicationFormsController < AdminController
    before_action :load_form

    def show
    end

    def edit
    end

    def update
    end

    private

    def load_form
      @form = ApplicationForm.last
      @form ||= ApplicationForm.create
    end
  end
end
