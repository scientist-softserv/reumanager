module ReuProgram
  class SectionsController < AdminController
    before_action :load_form
    before_action :load_section, except: %i[new create]

    def show; end

    def new
      @section = Section.new
    end

    def create
      @section = @form.sections.build(section_params)
      if @section.save
        redirect_to edit_reu_program_application_form_section_path(@form, @section)
      else
        render :new
      end
    end

    def edit; end

    def update
      if @section.update(section_params)
        redirect_to edit_reu_program_application_form_section_path(@form, @section)
      else
        render :edit
      end
    end

    def update_attributes
      @section.assign_attributes(section_params)
      @section.handle_add_field
      @section.errors.clear
      @section.fields.each { |q| q.errors.clear }
      render partial: 'form', layout: false
    end

    def destroy
      if @section.destroy
        redirect_to edit_reu_program_application_form_path(@form)
      else
        redirect_back fallback_location: edit_reu_program_application_form_path(@form)
      end
    end

    private

    def load_form
      @form = ApplicationForm.find(params[:application_form_id])
    end

    def load_section
      @section = @form.sections.find(params[:id])
    end

    def section_params
      params.require(:section).permit!
    end
  end
end
