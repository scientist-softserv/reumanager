module Questions
  class Boolean < Question
    define_property :type, default: 'boolean', setable: false

    def default_name
      'Boolean Question'
    end
  end
end
