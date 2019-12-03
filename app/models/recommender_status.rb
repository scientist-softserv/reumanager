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
    validate_data
  end

  def validate_data
    return unless current_recommender_form
    validations = current_recommender_form.validations['recommendation_form']
    form_data = data.fetch('recommendation_form', {})
    validations.each do |field, validation|
      validation.each do |type, details|
        add_errors(type, details, form_data[field])
      end
    end
  end

  def data_valid?
    return @data_valid unless @data_valid.nil?
    self.errors.clear
    validate_data
    @data_valid = self.errors.empty?
  end

  def add_errors(type, details, value, append_msg = '')
    message = append_msg.present? ? "#{append_msg} #{details[:message]}" : details[:message]
    errors.add(:base, message) if type.to_s == 'required' && [nil, ''].include?(value)
    return if value.nil?
    errors.add(:base, message) if type.to_s == 'max_length' && value.size > details[:max]
  end

  def current_recommender_form
    @current_recommender_form ||= RecommenderForm.includes(sections: :fields).where(status: :active).first
  end
end
