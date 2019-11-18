module ReuProgram
  class FieldsController < AdminController
    before_action :load_form
    before_action :load_section
    before_action :load_field, except: %i[create]

    def show; end

    def create
      return redirect if params[:field_type].blank?
      field_type = params[:field_type]
      return redirect if Field::TYPES.values.exclude?(field_type)
      order = (@section.fields.to_a.map(&:order).max || 0) + 1
      klass = field_type.constantize
      @field = klass.create(order: order, section: @section, required: true)
      render json: { success: true, path: edit_form_path(with_field: true) }
    end

    def edit
      render layout: false
    end

    def update
      if @field.update(field_params)
        flash[:notice] = 'successfully updated field'
      else
        flash[:alert] = 'Failed to update field'
      end
      redirect_to edit_form_path(with_field: true)
    end

    def destroy
      if @field.destroy
        flash[:notice] = 'Successfully removed field'
      else
        flash[:alert] = 'Failed to remove Field'
      end
      redirect_to edit_form_path
    end

    private

    def edit_form_path(with_field: false)
      options = { section_id: @section.id }
      options[:field_id] = @field.id if with_field
      case @form
      when ApplicationForm
        edit_reu_program_application_form_path(@form, options)
      when RecommenderForm
        edit_reu_program_recommender_form_path(@form, options)
      end
    end

    def field_params
      params.require(:field).permit!
    end

    def load_form
      @form = ApplicationForm.find_by_id(params[:application_form_id])
      @form ||= RecommenderForm.find_by_id(params[:recommender_form_id])
      raise ActionController::RoutingError, 'Not Found' if @form.blank?
    end

    def load_section
      @section = @form.sections.find(params[:section_id])
    end

    def load_field
      @field = @section.fields.find(params[:id])
    end
  end
end
