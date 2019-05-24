class Setting < ApplicationRecord
  belongs_to :grant
  attr_accessor :display_name
  # attr_accessible :name, :description, :value, :display_name
  validates_uniqueness_of :name

  # Returns the value of the setting named name
  def self.[](name)
    if name.is_a? Symbol
      name = name.to_s.gsub('_', ' ').titleize
    end
    name = name.to_s
    setting = find_by_name(name)

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
