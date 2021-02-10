class Field < ApplicationRecord
  self.inheritance_column = :kind
  belongs_to :section

  TYPES = {
    'Short Text' => 'Fields::ShortText',
    'Long Text' => 'Fields::LongText',
    'Checkbox' => 'Fields::Boolean',
    'Select' => 'Fields::Select',
    'PDF File' => 'Fields::File',
    'Date' => 'Fields::Date'
  }.freeze

  class << self
    def define_properties
      @current_config = {}
      json_attrs = {}
      yield if block_given?
      @current_config.each do |name, opts|
        config = {}
        config[:default] = opts[:default] if opts[:default]
        config[:array] = opts[:array] if opts[:array]
        json_attrs[name] = [opts[:type], config]
        define_method("#{name}_in_form?") { opts[:in_form?] || false }
        define_method("#{name}_options") { opts[:options] }
        define_method("#{name}_hint") { opts[:hint] || '' }
      end
      jsonb_accessor :config, json_attrs
    end

    def property(property_name, opts = {})
      @current_config[property_name] = opts
    end
  end

  def title_key
    title.downcase.tr(' ', '_')
  end

  def validate_data(value, index = nil)
    [
      required_applies? ? validate_required(value, index) : nil,
      min_length_applies? ? validate_min_length(value, index) : nil,
      max_length_applies? ? validate_max_length(value, index) : nil
    ].compact
  end

  def required_applies?
    self.respond_to?(:required) && self.required
  end

  def validate_required(value, index = nil)
    value.present? ? nil : "#{title}#{" #{index + 1}" if index.present?} is required"
  end

  def min_length_applies?
    self.respond_to?(:min_length) && self.min_length.present? && self.min_length > 0
  end

  def validate_min_length(value, index = nil)
    value.size > self.min_length ? nil : "#{title}#{" #{index + 1}" if index.present?} must be at least #{min_length} characters long"
  end

  def max_length_applies?
    self.respond_to?(:max_length) && self.max_length.present? && self.max_length > 0
  end

  def validate_max_length(value, index = nil)
    value.size < self.max_length ? nil : "#{title}#{" #{index + 1}" if index.present?} cannot use more than #{max_length} characters"
  end

  def dependancy_config
    {}
  end
end
