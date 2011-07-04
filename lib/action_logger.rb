require "active_support/dependencies"
require "action_logger/base"

module ActionLogger
  # Our host application root path
  # We set this when the engine is initialized
  #mattr_accessor :app_root

  # Yield self on setup for nice config blocks
  #def self.setup
    #yield self
  #end
  class Engine < Rails::Engine
  end if defined?(Rails) && Rails::VERSION::MAJOR == 3
end

# Require our engine
#require "action_logger/engine"

