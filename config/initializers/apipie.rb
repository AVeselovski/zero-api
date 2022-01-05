# frozen_string_literal: true

Apipie.configure do |config|
  config.app_name                = "ZeroApi"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/docs"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.translate               = false
  config.default_version         = "v1"
end
