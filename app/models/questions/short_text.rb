module Questions
  class ShortText < Question
    define_property :type, default: 'string', setable: false
    define_property :format, hint: "Validate the input to be formatted for special kinds of information. Choose default if this doesn't apply", options: %w[text email url]
    define_property :min_length, hint: 'Specify a minimum length of for in input value'
  end
end
