module Fields
  class Select < Field
    define_properties do
      property :title, type: :string, hint: 'Question text'
      property :description, type: :string, hint: 'Hint to user about what the field is asking for. optional'
      property :required, type: :boolean, default: true, hint: 'Field will be required'
      # property :type, type: :string, default: 'string', in_form: false
      property :enum_array, type: :string, array: true, default: [], hint: 'A comma separated list of options ex: option 1, option 2, other option'
    end

    validates :title, presence: true, on: :update

    before_save do
      self.dependant_config = {} unless self.use_dependant_fields?
      self.dependant_config = self.dependant_config.select do |option, _value|
        self.enum_array.include?(option)
      end
    end

    def use_dependent_fields=(new_value)
      @use_dependant_fields = ActiveModel::Type::Boolean.new.cast(new_value)
    end

    def use_dependant_fields?
      @use_dependant_fields
    end

    def options
      self.enum_array.join(', ')
    end

    def options=(new_value)
      if new_value.is_a?(Array) && new_value.all? { |v| v.is_a?(String) }
        self.enum_array = new_value
      elsif new_value.is_a?(String)
        self.enum_array = new_value.split(',').map(&:strip)
      end
    end

    def options_hint
      self.enum_array_hint
    end

    def default_name
      'Select Field'
    end

    def json_config
      {
        title_key => {
          title: "#{title}#{' *' if required}",
          type: :string,
          description: description,
          enum: enum_array,
          enumNames: enum_array
        }.reject { |_k, v| v.blank? }
      }
    end

    def dependacies_config
      {
        title_key => {
          oneOf: self.dependant_config.each_with_object([]) do |(key, value), array|
            h = { properties: { title_key => { 'enum' => [key] } } }
            h[:properties][value] = { type: :string } if value.present?
            array << h
          end
        }
      }
    end

    def ui_config
      {}
    end
  end
end
