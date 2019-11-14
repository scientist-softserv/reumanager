class Setting < ApplicationRecord
  self.inheritance_column = :kind
  validates_uniqueness_of :name

  class << self
    def [](lookup)
      settings_array = self.all.to_a
      setting = settings_array.detect do |s|
        s.name == lookup || s.name.downcase.tr(' ', '_') == lookup.to_s.downcase.tr(' ', '_')
      end
      case setting
      when Settings::DateSetting
        setting&.value&.to_date
      else
        setting&.value
      end
    end

    def all_setup?
      self.all.all? { |s| s.value.present? }
    end
  end

  after_save do
    self.class.settings_array = nil
  end

  def display_name
    name.tr('_', ' ').titleize
  end
end
