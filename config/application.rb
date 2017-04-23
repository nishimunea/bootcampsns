require File.expand_path('../boot', __FILE__)

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"

require 'digest/md5'
require 'securerandom'
require 'rmagick'

Bundler.require(*Rails.groups)

module Sns
  class Application < Rails::Application
    config.action_controller.permit_all_parameters = true # エラー抑止のため
    config.active_record.raise_in_transactional_callbacks = true
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
  end
end
