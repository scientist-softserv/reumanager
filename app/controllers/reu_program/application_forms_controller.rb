module ReuProgram
  class ApplicationFormsController < AdminController
    before_action :load_form, except: %i[index]

    def index
      @forms = ApplicationForm.all
    end

    def show; end

    def edit; end

    def update
      @form.assign_attributes(form_params)
    end

    def update_attributes
      @form.assign_attributes(form_params)
      render partial: 'edit_form', layout: false
    end

    private

    def form_params
      params.require(:application_form).permit!
    end

    def load_form
      @form = ApplicationForm.find(params[:id])
    end
  end
end
