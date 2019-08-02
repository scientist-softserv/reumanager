class Snippet < ApplicationRecord
  self.inheritance_column = :kind
  belongs_to :grant
  has_one_attached :image

  validates_uniqueness_of :name

  class << self
    attr_accessor :snippets_array

    def [](lookup)
      snippets_array = self.all.to_a if snippets_array.nil?
      snippet = snippets_array.detect do |s|
        s.name == lookup || s.name.downcase.tr(' ', '_') == lookup.to_s.downcase.tr(' ', '_')
      end
      snippet&.value || ''
    end

    def load_from_yaml(grant = nil)
      default_snippets = YAML.safe_load(File.open(Rails.root.join('config', 'snippets.yml')))
      default_snippets.map do |s|
        Snippet.find_or_create_by(name: s[1]['name']) do |snippet|
          snippet.grant = grant
          snippet.description = s[1]['description']
          snippet.name = s[1]['name']
          snippet.value = s[1]['value']
        end
      end
    end
  end

  def display_name
    name.tr('_', ' ').titleize
  end
end
