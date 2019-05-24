module Questions
  class LongText < Question
    define_property :type, default: 'string', setable: false, in_form: false
    define_propery :min_length, hint: 'Specify a minimum length of for in input value'

    def widget
      'textarea'
    end
  end
end
