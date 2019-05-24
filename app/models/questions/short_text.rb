module Questions
  class ShortText < Question
    define_property :type, default: 'string', setable: false
    define_propery :format, hint: "Validate the input to be formatted for special kinds of information. Choose default if this doesn't apply", options: %w[email url]
    define_propery :min_length, hint: 'Specify a minimum length of for in input value'
  end
end
