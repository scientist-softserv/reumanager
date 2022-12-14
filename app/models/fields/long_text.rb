module Fields
  class LongText < Field
    define_properties do
      property :title, type: :string, hint: 'Question text'
      property :description, type: :string, hint: 'Hint to user about what the field is asking for. optional'
      property :required, type: :boolean, default: true, hint: 'Field will be required'
      # property :type, type: :string, default: 'string', in_form: false
      property :max_length, type: :integer, hint: 'Specify a maximum length of for in input value'
    end

    validates :title, presence: true, on: :update

    def widget
      'textarea'
    end

    def default_name
      'Long Text Field'
    end

    def json_config
      {
        title_key => {
          type: :string,
          title: "#{title}#{' *' if required}",
          description: description
        }.reject { |_k, v| v.blank? }
      }
    end

    def ui_config
      {
        title_key => {
          'ui:widget': 'textarea'
        }
      }
    end
  end
end
