namespace :action_logger do
  desc "Add the Database Tables needed for ActionLogger"
  task :install => [:environment] do
    ActiveRecord::Schema.define do
      create_table :action_loggers do |t|
        t.string     :controller
        t.string     :action
        t.text       :request_parameters
        t.string     :request_method
        t.string     :request_url, :limit => 1024
        t.string     :remote_ip
        t.references :user
        t.datetime   :created_at
      end
    end
  end
  
  task :uninstall => [:environment] do
    ActiveRecord::Schema.define do
      drop_table :action_loggers
    end
  end
  
  task :reinstall => [:uninstall, :install]
  
  desc "Clear action_logs table"
  task :clear => :environment do
    ActionLog.delete_all
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

