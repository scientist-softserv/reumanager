class RecommenderStatus < ApplicationRecord
  belongs_to :application

  validate :run_data_validations

  after_commit do
    if self.application.can_complete?
      self.application.complete
      self.application.save
    end
  end

  def run_data_validations
    return unless self.changed.include?('data')
    validations = current_recommender_form.validations['recommendation_form']
    data_is_valid = true
    form_data = data
    data_is_valid = false if form_data.blank?
    validations.each do |type, msg|
      next unless type.to_s == 'required' && [nil, ''].include?(form_data[key])
      data_is_valid = false
      errors.add(:base, msg)
    end
    self.data_valid = data_is_valid
  end

  def current_recommender_form
    @current_recommender_form ||= RecommenderForm.includes(sections: :fields).where(status: :active).first
  end
end
