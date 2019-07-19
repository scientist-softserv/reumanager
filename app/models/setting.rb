class Setting < ApplicationRecord
  belongs_to :grant
  validates_uniqueness_of :name

  class << self
    attr_accessor :settings_array

    def [](lookup)
      settings_array = self.all.to_a if settings_array.nil?
      setting = settings_array.detect do |s|
        s.name == lookup || s.name.downcase.tr(' ', '_') == lookup.to_s.downcase.tr(' ', '_')
      end

      setting.value || ''
    end

    def self.load_from_yaml(grant = nil)
      default_settings = YAML.safe_load(File.open(Rails.root.join('config', 'settings.yml')))
      default_settings.map do |s|
        Setting.find_or_create_by(name: s[1]['name']) do |setting|
          setting.grant = grant
          setting.description = s[1]['description']
          setting.name = s[1]['name']
          setting.value = s[1]['value']
        end
      end
    end
  end

  after_save do
    self.class.settings_array = nil
  end

  def display_name
    name.tr('_', ' ').titleize
  end
end
