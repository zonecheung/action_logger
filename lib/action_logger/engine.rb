module ActionLogger

  class Engine < Rails::Engine

    initialize "action_logger.load_app_instance_data" do |app|
      ActionLogger.setup do |config|
        config.app_root = app.root
      end
    end

    initialize "action_logger.load_static_assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

  end

end

