class Setting < ApplicationRecord
  belongs_to :grant
  attr_accessor :display_name
  validates_uniqueness_of :name

  # Returns the value of the setting named name
  def self.[](lookup)
    name = lookup.to_s.tr('_', ' ').titleize
    setting = self.where('name = ? OR name = ?', lookup.to_s, name).first
    setting ? setting.value : nil
  end

  def self.load_from_yaml(grant=nil)
    default_settings = YAML::load(File.open(Rails.root.join 'config', 'settings.yml'))
    default_settings.map do |s|
     Setting.find_or_create_by(name: s[1]['name']) do |setting|
        setting.grant = grant
        setting.description = s[1]['description']
        setting.name = s[1]['name']
        setting.value = s[1]['value']
      end
    end
  end

  def display_name
    name.gsub('_',' ').titleize
  end
end
