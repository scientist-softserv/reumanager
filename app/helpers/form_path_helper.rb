module FormPathHelper
  def fields_path(section = nil)
    section = @section if @section.present?
    case @form
    when ApplicationForm
      reu_program_application_form_section_fields_path(@form, section)
    when RecommenderForm
      reu_program_recommender_form_section_fields_path(@form, section)
    end
  end

  def field_path(field, section = nil)
    section = @section if @section.present?
    case @form
    when ApplicationForm
      reu_program_application_form_section_field_path(@form, section, field)
    when RecommenderForm
      reu_program_recommender_form_section_field_path(@form, section, field)
    end
  end

  def edit_field_path(field, section = nil)
    section = @section if @section.present?
    case @form
    when ApplicationForm
      edit_reu_program_application_form_section_field_path(@form, section, field)
    when RecommenderForm
      edit_reu_program_recommender_form_section_field_path(@form, section, field)
    end
  end

  def field_update_path(field, section = nil)
    section = @section if @section.present?
    case @form
    when ApplicationForm
      reu_program_application_form_section_field_path(@form, section, field)
    when RecommederForm
      reu_program_recommender_form_section_field_path(@form, section, field)
    end
  end
end
