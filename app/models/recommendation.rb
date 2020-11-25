class Recommendation < ApplicationRecord
  belongs_to :application

  validate :run_data_validations, on: :update

  after_commit do
    if self.application.can_complete?
      self.application.complete
      self.application.save
    end
  end

  def run_data_validations
    return unless self.changed.include?('data')
    validate_data
  end

  def validate_data
    return unless current_recommender_form
    form_data = data.fetch('recommendation_form', {})
    if form_data.blank?
      errors.add(:base, 'Recommendation not filled out')
      return
    end
    self.current_recommender_form
        .recommendation_section
        .validate_data(form_data)
        .each { |msg| errors.add(:base, msg) }
  end

  def data_valid?
    return @data_valid unless @data_valid.nil?
    self.errors.clear
    validate_data
    @data_valid = self.errors.empty?
  end

  def current_recommender_form
    @current_recommender_form ||= RecommenderForm.includes(sections: :fields).where(status: :active).first
  end
end
