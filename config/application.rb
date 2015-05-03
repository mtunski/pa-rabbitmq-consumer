require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module RabbitmqConsumer
  class Application < Rails::Application
    config.autoload_paths += %W(#{Rails.root}/app/workers)

    config.active_record.raise_in_transactional_callbacks = true
  end
end
