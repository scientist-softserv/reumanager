class Field < ApplicationRecord
  self.inheritance_column = :kind
  belongs_to :section

  TYPES = {
    'Short Text' => 'Fields::ShortText',
    'Long Text' => 'Fields::LongText',
    'Checkbox' => 'Fields::Boolean',
    'Select' => 'Fields::Select'
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

    def important_field_path(important_type)
      field = self.where(important: important_type).last
      [field.section.title_key, field.title_key]
    end
  end

  def title_key
    title.downcase.tr(' ', '_')
  end
end
