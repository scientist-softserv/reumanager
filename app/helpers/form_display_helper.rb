module FormDisplayHelper
  def format_value(value, model, model_id, access_path)
    if value =~ /^data:/
      link_to 'Download', download_path(model, model_id, access_path, format: :pdf)
    else
      value
    end
  end

  def format_key(key)
    key.tr('_', ' ').titlecase
  end
end
