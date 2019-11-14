class RecommenderFormsController < ApplicationController
  before_action :authenticate_user!
  before_action :setup_application

  def show_recommenders
    @form = RecommenderForm.includes(sections: :fields).where(status: :active).first
  end

  def update_recommenders
    current_user.application.recommender_info = params.require(:data).permit!
    if current_user.application.save
      current_user.application.update_recommender_status
      current_user.application.recommender_statuses.each do |status|
        next if status.last_sent_at.present?
        status.update(last_sent_at: Time.current)
        Notification.recommendation_request(status, current_user.application).deliver
      end
      render json: { success: true, message: 'Successfully saved the form' }
    else
      current_user.application.save(validate: false)
      render json: {
        success: false,
        message: 'There are errors in the form',
        errors: current_user.application.errors.full_messages
      }
    end
  end
end
