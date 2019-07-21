class ApplicantDataController < ApplicationController
  before_action :load_applicant

  def show_application

  end

  def update_application

  end

  def show_recommenders

  end

  def update_recommenders

  end

  def status

  end

  private

  def load_applicant
    @applicant = current_applicant
  end
end
