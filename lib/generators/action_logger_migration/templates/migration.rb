class CreateActionLoggers < ActiveRecord::Migration
  def self.up
    create_table :action_logs do |t|
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

  def self.down
    drop_table :action_logs
  end
end
