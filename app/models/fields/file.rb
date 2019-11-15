module Fields
  class File < Field
    define_properties do
      property :title, type: :string, hint: 'Question text'
      property :description, type: :string, hint: 'Hint to user about what the question is asking for. optional'
      property :required, type: :boolean, default: true, hint: 'Field will be required'
      property :min_length, type: :integer, hint: 'Specify a minimum length of for in input value'
    end

    validates :title, presence: true, on: :update

    def default_name
      'PDF File Field'
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
          format: 'data-url'
        }.reject { |_k, v| v.blank? }
      }
    end

    def ui_config
      {
        title_key => {
          'ui:options': {
            'accept': '.pdf' # if more fomats are allowed update the download route's constrait
          }
        }
      }
    end
  end
end
