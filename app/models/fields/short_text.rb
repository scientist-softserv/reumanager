module Fields
  class ShortText < Field
    define_properties do
      property :title, type: :string, hint: 'Question text'
      property :description, type: :string, hint: 'Hint to user about what the question is asking for. optional'
      property :required, type: :boolean, default: true, hint: 'Field will be required'
      property :min_length, type: :integer, hint: 'Specify a minimum length of for in input value'
    end

    validates :title, presence: true, on: :update
 
    def default_name
      'Short Text Field'
    end

    def json_config
      {
        title_key => {
          type: :string,
          title: "#{title}#{' *' if required}",
          description: description,
          format: :text,
          minLength: min_length
        }.reject { |_k, v| v.blank? }
      }
    end

    def ui_config
      {}
    end
  end
end
