module Fields
  class Boolean < Field
    define_properties do
      property :title, type: :string, hint: 'Question text'
      property :description, type: :string, hint: 'Hint to user about what the field is asking for. optional'
      property :required, type: :boolean, default: false, hint: 'Field will be required'
      # property :type, type: :string, default: 'boolean'
    end

    validates :title, presence: true

    def default_name
      'Boolean Field'
    end

    def json_config
      {
        title_key => {
          type: :string,
          description: description
        }.reject { |_k, v| v.blank? }
      }
    end

    def ui_config
      {}
    end
  end
end
