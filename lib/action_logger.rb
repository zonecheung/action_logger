require "action_logger/base"

module ActionLogger
  class Engine < Rails::Engine
  end if defined?(Rails) && Rails::VERSION::MAJOR == 3
end

