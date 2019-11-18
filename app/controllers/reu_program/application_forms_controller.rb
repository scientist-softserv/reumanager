module ReuProgram
  class ApplicationFormsController < AdminController
    before_action :load_form, except: %i[index]

    def index
      @forms = ApplicationForm.order(status: :desc, created_at: :desc)
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

    def reorder_sections
      if params[:reorder_sections].present? || !@form.sections.exists?
        ids = params[:reorder_sections].split('--').map(&:to_i)
        if ids.count == @form.sections.count
          @form.sections.each do |section|
            section.update(order: (ids.index(section.id) + 1))
          end
          flash[:notice] = 'Section order updated'
        else
          flash[:alert] = 'Could not reorder sections, please contact an admin'
        end
      else
        flash[:alert] = 'Could not reorder sections, there are no sections to reorder, please contact an admin'
      end
      redirect_to edit_reu_program_application_form_path(@form)
    end

    def make_active
      ApplicationForm.transaction do
        ApplicationForm.all.each(&:draft!)
        @form.active!
      end
      redirect_to reu_program_application_forms_path
    end

    def duplicate
      @form.duplicate
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
