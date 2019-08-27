module ReuProgram
  class ApplicationFormsController < AdminController
    before_action :load_form, except: %i[index]

    def index
      @forms = ApplicationForm.all
    end

    def show; end

    def show_schema; end

    def edit; end

    def update
      if @form.update(form_params)
        redirect_to edit_reu_program_application_form_path(@form)
      else
        render :edit
      end
    end

    def make_active
      ApplicationForm.transaction do
        ApplicationForm.all.each(&:draft!)
        @form.active!
      end
      redirect_to reu_program_application_forms_path
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
