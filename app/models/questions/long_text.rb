module Questions
  class LongText < Question
    define_property :type, default: 'string', setable: false, in_form: false
    define_property :min_length, hint: 'Specify a minimum length of for in input value'

    def widget
      'textarea'
    end

    def default_name
      'Long Text Question'
    end
  end
end
