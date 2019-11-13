class DownloadController < ApplicationController
  before_action :check_params, :load_model

  def download
    data = @model.send(access_method)
    not_found if data.blank? || !data.respond_to?(:dig)
    url = data.dig(*fields)
    uri = URI::Data.new(url)
    send_data uri.data, filename: filename(url), type: uri.content_type, disposition: :attachment
  end

  private

  def check_params
    params[:model_id].present? &&
      params[:model_type].present? &&
      params[:field].present? &&
      params[:format] == 'pdf'
  end

  def load_model
    klass = load_constant
    @model = klass.find(params[:model_id])
  end

  def load_constant
    case params[:model_type]
    when 'application'
      Application
    when 'recommender'
      Application
    when 'recommendation'
      RecommenderStatus
    else
      not_found
    end
  end

  def access_method
    case params[:model_type]
    when 'application'
      :data
    when 'recommender'
      :recommender_info
    when 'recommendation'
      :data
    end
  end

  def fields
    @fields ||= params[:field].split('--').map { |e| e =~ /\d+/ ? e.to_i : e }
  end

  def extract_filename(data)
    re = /name=(.*);/
    match = re.match(data)
    match ? match[1] : nil
  end

  def filename(data)
    name = extract_filename(data)
    name ||= "#{fields.last}.#{params[:format]}"
    name
  end

  def not_found
    raise ActionController::RoutingError, 'not found'
  end
end
