require "aws/s3"
require "iconv"

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

  desc "Dump action_logs to YAML file"
  task :dump => [:environment] do
    def recursively_convert_utf_content(attrs)
      ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      attrs.each do |key, value|
        attrs[key] = case value
        when Hash
          recursively_convert_utf_content(value)
        when String
          ic.iconv(value + "  ")[0..-3]  # Add 2 spaces and remove them back after conversion to prevent error.
        else
          value
        end
      end
      attrs
    end

    conditions = ["1=1"]
    # Assign conditions.
    unless ENV["start_date"].blank? 
      conditions[0] << " AND created_at >= ?"
      conditions << ENV["start_date"]
    end
    unless ENV["end_date"].blank?
      conditions[0] << " AND created_at <= ?"
      conditions << ENV["end_date"]
    end
    unless ENV["start_time"].blank? 
      conditions[0] << " AND created_at >= ?"
      conditions << ENV["start_time"]
    end
    unless ENV["end_time"].blank?
      conditions[0] << " AND created_at <= ?"
      conditions << ENV["end_time"]
    end
    unless ENV["method"].blank?
      conditions[0] << " AND request_method = ?"
      conditions << ENV["method"]
    end
    unless ENV["user_id"].blank?
      conditions[0] << " AND user_id = ?"
      conditions << ENV["user_id"]
    end
    file = if ! ENV["s3_access_key_id"].blank?
      AWS::S3::Base.establish_connection!(
        :access_key_id     => ENV['s3_access_key_id'],
        :secret_access_key => ENV['s3_secret_access_key'],
        :use_ssl           => true
      )
      filename = ENV["filename"].blank? ? "action_logs_#{DateTime.now.to_i}.yml" :
                   File.basename(ENV["filename"])
      File.new("./tmp/#{filename}", "w")
    elsif ! ENV["filename"].blank?
      File.new(ENV["filename"], "w")
    end
    
    ActionLog.find_each(:conditions => conditions) do |action_log|
      action_log.request_parameters = recursively_convert_utf_content(action_log.request_parameters)
      # Output record id first, this only has effect on Ruby 1.9.
      yaml = { "id" => action_log.id }.merge(action_log.attributes).to_yaml
      unless file.nil?
        file.write(yaml)
      else
        puts yaml
      end
    end
    file.close unless file.nil?
    puts "Total entries: #{ActionLog.count(:conditions => conditions)}"
    unless ENV["s3_access_key_id"].blank?
      AWS::S3::S3Object.store (ENV["filename"] || filename), open(file), ENV["s3_bucket"]
      #stored = AWS::S3::Service.response.success?
      AWS::S3::Base.disconnect!
      File.delete(file)
    end
  end

end

