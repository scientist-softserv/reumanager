module Settings
  class UrlSetting < Setting
    validates :value, http_url: true
  end
end
