module Fields
  class Date < Field
    define_properties do
      property :title, type: :string, hint: 'Question text'
      property :description, type: :string, hint: 'Hint to user about what the field is asking for. optional'
      property :required, type: :boolean, default: false, hint: 'Field will be required'
      property :type, type: :datetime, default: 'string', in_form: false
    end

    validates :title, presence: true

    def default_name
      'Date Field'
    end
  end
end
