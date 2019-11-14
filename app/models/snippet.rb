class Snippet < ApplicationRecord
  self.inheritance_column = :kind

  validates_uniqueness_of :name

  class << self
    def [](lookup)
      snippets_array = self.all.to_a
      snippet = snippets_array.detect do |s|
        s.name == lookup || s.name.downcase.tr(' ', '_') == lookup.to_s.downcase.tr(' ', '_')
      end
      case snippet
      when Snippets::ImageSnippet
        snippet.image.attached? ? snippet.image : nil
      else
        snippet&.value || ''
      end
    end

    def all_setup?
      self.all.all? { |s| s.value.present? || s.image.attached? }
    end
  end

  def display_name
    name.tr('_', ' ').titleize
  end
end
