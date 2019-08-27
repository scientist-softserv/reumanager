class ApplicantDataController < ApplicationController
  before_action :load_applicant

  def show_application
    @form = ApplicationForm.where(status: :draft).first
  end

  def update_application
    @applicant.data = params.require(:data).permit!
    @applicant.save
    render json: {}
  rescue ActionController::ParameterMissing
    render json: {}
  end

  def show_recommenders
    @form = RecommenderForm.where(status: :active).first
  end

  def update_recommenders
    @applicant.recommender_info = params.require(:data).permit!
    @applicant.save
    render json: {}
  rescue ActionController::ParameterMissing
    render json: {}
  end

  def status
    # @form = ApplicationForm.where(status: :draft).first
    # @form = ApplicationForm.find(params[:id])
    @applicant
  end

  private

  def form_params
    params.require(:application_form).permit!
  end

  def load_form
    @form = ApplicationForm.find(params[:id])
  end

  def load_applicant
    @applicant = current_applicant
  end

  def process_recommender_data
    data = params.require(:data).permit!
    data.each do |key, info|
      recommender_builder(key, info)
    end
  end
  
  def process_application_data
    data = params.require(:data).permit!
    data.each do |key, info|
      application_builder(key, info)
    end
  end

  class NoEmailError < StandardError; end

  def recommender_builder(order, info)
    email = info.dig('recommenders_form', 'email')
    raise NoEmailError, 'no email' if email.blank?
    r = current_applicant.recommenders.find_or_initialize_by(email: email)
    r.order = order
    r.info = info['recommenders_form']
    r.applicant = current_applicant
    r.save
  end
  
  def application_builder(order, info)
    email = info.dig('application_form', 'email')
    raise NoEmailError, 'no email' if email.blank?
    a = current_applicant.application.find_or_initialize_by(email: email)
    a.order = order
    a.info = info['application_form']
    a.applicant = current_applicant
    a.save
  end
end
