require "action_logger/base"

module ActionLogger
  class Engine < Rails::Engine
    initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end
  end if defined?(Rails) && Rails::VERSION::MAJOR == 3
end

