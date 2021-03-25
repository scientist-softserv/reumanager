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
        setting&.value&.in_time_zone(setting.time_zone)&.to_datetime&.end_of_day
      else
        setting&.value
      end
    end

    def all_setup?
      self.all.all? { |s| s.value.present? || s.optional? }
    end
  end

  def display_name
    name.tr('_', ' ').titleize
  end
end
