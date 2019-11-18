module Fields
  class ShortText < Field
    define_properties do
      property :title, type: :string, hint: 'Question text'
      property :description, type: :string, hint: 'Hint to user about what the question is asking for. optional'
      property :required, type: :boolean, default: true, hint: 'Field will be required'
      # property :type, type: :string, default: 'string', in_form: false
      property :format, type: :string, hint: "Validate the input to be formatted for special kinds of information. Choose default if this doesn't apply", options: %w[text email url date date-time]
      property :min_length, type: :integer, hint: 'Specify a minimum length of for in input value'
    end

    validates :title, presence: true, on: :update
    validates :format, inclusion: { in: %w[text email url date date-time] }

    before_validation do
      self.format ||= 'text'
    end

    def default_name
      'Short Text Field'
    end

    def dependancy_config
      {
        self.dependant.title_key => {
          'true' => {
            properties: json_config
          }
        }
      }
    end

    def json_config
      {
        title_key => {
          type: :string,
          title: title,
          description: description,
          format: format == 'test' ? nil : format,
          minLength: min_length
        }.reject { |_k, v| v.blank? }
      }
    end

    def ui_config
      {}
    end
  end
end
