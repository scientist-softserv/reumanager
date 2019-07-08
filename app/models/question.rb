class Question < ApplicationRecord
  self.inheritance_column = :kind
  belongs_to :section

  TYPES = {
    'Short Text' => 'Questions::ShortText',
    'Long Text'  => 'Questions::LongText',
    'Checkbox'   => 'Questions::Boolean',
    'Select'     => 'Questions::Select',
    'Select with Follow Up' => 'Questions::SelectWithFollowup'
  }

  class << self
    def define_property(property_name, opts = {})
      str_name = property_name.to_s
      define_method("#{str_name}_in_form?") { opts[:in_form?] || false }
      define_method("#{str_name}_options") { opts[:options] }
      define_method("#{str_name}_hint") { opts[:hint] || '' }
      define_method(str_name) do
        self.config[str_name] ||= opts[:default]
        self.config[str_name]
      end
      if opts[:options].respond_to?(:any?) && opts[:options]&.any?
        opts[:options] << 'default'
        validates str_name, inclusion: { in: opts[:options] }
      end
      return unless opts[:setable]
      define_method("#{str_name}=") do |new_value|
        self.config[str_name] = new_value
      end
    end
  end

  def assign_attributes(hash)
    hash.each do |key, value|
      self.send("#{key}=", value) if self.respond_to?("#{key}=")
    end
  end

  define_property :title, hint: 'Question text'
  define_property :description, hint: 'Hint to user about what the question is asking for. optional'
  define_property :required, default: false, hint: 'Field will be required'

  validates :title, :description, presence: true
end
