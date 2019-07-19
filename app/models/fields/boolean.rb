module Fields
  class Boolean < Question
    define_properties do
      property :title, type: :string, hint: 'Question text'
      property :description, type: :string, hint: 'Hint to user about what the field is asking for. optional'
      property :required, type: :boolean, default: false, hint: 'Field will be required'
      define_property :type, default: 'boolean'
    end

    validates :title, presence: true

    def default_name
      'Boolean Question'
    end
  end
end
