module Questions
  class Select < Question
    define_property :type, default: 'string', setable: false
    define_property :enum, default: []
  end
end
