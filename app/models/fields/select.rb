module Fields
  class Select < Question
    define_properties do
      property :title, type: :string, hint: 'Question text'
      property :description, type: :string, hint: 'Hint to user about what the field is asking for. optional'
      property :required, type: :boolean, default: false, hint: 'Field will be required'
      property :type, type: :string, default: 'string', in_form: false
      property :enum_array, type: :string, array: true, default: [], hint: 'A comma separated list of options ex: option 1, option 2, other option'
    end
    define_property :type, default: 'string', setable: false

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
      'Select Question'
    end
  end
end
