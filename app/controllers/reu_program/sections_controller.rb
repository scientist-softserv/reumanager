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
        redirect_to_section
      else
        render :new
      end
    end

    def edit; end

    def update
      if @section.update(section_params)
        redirect_to_section
      else
        render :edit
      end
    end

    def reorder_fields
      if params[:reorder_fields].present? || !@section.fields.exists?
        ids = params[:reorder_fields].split('--').map(&:to_i)
        if ids.count == @section.fields.count
          @section.fields.each { |f| f.update(order: (ids.index(f.id) + 1)) }
          flash[:notice] = 'Section order updated'
        else
          flash[:alert] = 'Could not reorder sections, please contact an admin'
        end
      else
        flash[:alert] = 'Could not reorder sections, there are no sections to reorder, please contact an admin'
      end
      redirect_to_form
    end

    # only sections on application forms can be destroyed
    def destroy
      if @section.destroy
        redirect_to edit_reu_program_application_form_path(@form)
      else
        redirect_back fallback_location: edit_reu_program_application_form_path(@form)
      end
    end

    private

    def redirect_to_form
      if params[:application_form_id].present?
        redirect_to edit_reu_program_application_form_path(@form)
      elsif params[:recommender_form_id].present?
        redirect_to edit_reu_program_recommender_form_path(@form)
      end
    end

    def redirect_to_section
      if params[:application_form_id].present?
        redirect_to edit_reu_program_application_form_section_path(@form, @section)
      elsif params[:recommender_form_id].present?
        redirect_to edit_reu_program_recommender_form_section_path(@form, @section)
      end
    end

    def load_form
      @form = ApplicationForm.find_by_id(params[:application_form_id])
      @form ||= RecommenderForm.find_by_id(params[:recommender_form_id])
      raise ActionController::RoutingError, 'Not Found' if @form.blank?
    end

    def load_section
      @section = @form.sections.find(params[:id])
    end

    def add_field_params
      params.require(:section).permit(:add_field)
    end

    def section_params
      params.require(:section).permit!
    end
  end
end
