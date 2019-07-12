module Questions
  class Select < Question
    define_property :type, default: 'string', setable: false
    define_property :enum_array, default: [], hint: 'A comma separated list of options ex: option 1, option 2, other option'

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
  end
end
