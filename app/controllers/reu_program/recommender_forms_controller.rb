module ReuProgram
  class RecommenderFormsController < AdminController
    before_action :load_form, except: %i[index]

    def index
      @forms = RecommenderForm.all
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

    private

    def form_params
      params.require(:application_form).permit!
    end

    def load_form
      @form = RecommenderForm.find(params[:id])
    end
  end
end
