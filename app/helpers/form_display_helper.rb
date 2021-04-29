module FormDisplayHelper
  def format_value(value, model, model_id, access_path)
    if value =~ /^data:/
      link_to 'Download', download_path(model, model_id, access_path.tr('.', ''), format: :pdf)
    else
      value
    end
  end

  def format_key(key)
    key.tr('_', ' ').titlecase
  end

  def status_class(application_state)
    case application_state
    when 'started'
      'secondary'
    when 'submitted'
      'info'
    when 'completed'
      'primary'
    when 'withdrawn'
      'warning'
    when 'accepted'
      'success'
    when 'rejected'
      'dark'
    end
  end
end
