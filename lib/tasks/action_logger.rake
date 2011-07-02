namespace :action_logger do
  desc "Creates the action_logger table migration"
  task :migration => :environment do
    raise "Task unavailable to this database (no migration support)" unless ActiveRecord::Base.connection.supports_migrations?
    require 'rails_generator'
    require 'rails_generator/scripts/generate'
    Rails::Generator::Scripts::Generate.new.run(["action_logger_migration", ENV["MIGRATION"] || "AddActionLoggerTable"])
  end

  desc "Remove action_logs prior to certain days"
  task :remove => :environment do
    if ENV["keep"].blank? || ENV["keep"] !~ /^\d+$/
      puts "Usage: rake action_logger:remove keep=n"
    else
      ActionLog.delete_all(["created_at < ?", Date.today - ENV["keep"].to_i.days])
    end
  end
end
