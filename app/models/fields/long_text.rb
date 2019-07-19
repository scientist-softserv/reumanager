module Fields
  class LongText < Field
    define_properties do
      property :title, type: :string, hint: 'Question text'
      property :description, type: :string, hint: 'Hint to user about what the field is asking for. optional'
      property :required, type: :boolean, default: false, hint: 'Field will be required'
      property :type, type: :string, default: 'string', in_form: false
      property :min_length, type: :integer, hint: 'Specify a minimum length of for in input value'
    end

    validates :title, presence: true

    def widget
      'textarea'
    end

    def default_name
      'Long Text Field'
    end
  end
end
