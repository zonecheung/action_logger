module ActionLogger
  module Base
    def self.included(base)
      base.send :extend, ClassMethods
    end
   
    module ClassMethods

      def log_request(options = {})
        cattr_accessor :only, :except, :method, :none

        if options.is_a?(Hash)
          self.only   = ([options[:only]].flatten.compact || []).map(&:to_s)
          self.except = ([options[:except]].flatten.compact || []).map(&:to_s)
          self.method = ([options[:method]].flatten.compact || []).map { |x| x.to_s.upcase }
        else
          self.only   = []
          self.except = []
          self.method = []
          self.none   = options.to_s.downcase == "none"
        end

        before_filter :log_current_request_action
      end

    end

    def log_current_request_action
      if ! self.none &&
         (self.class.only.blank? || self.class.only.include?(params[:action])) &&
         (self.class.except.blank? || ! self.class.except.include?(params[:action])) &&
         (self.class.method.blank? || self.class.method.include?(request.method))
        ActionLog.create(:user_id            => current_user && current_user.id,
                         :controller         => params[:controller],
                         :action             => params[:action],
                         :request_parameters => params,
                         :request_url        => request.url,
                         :request_method     => request.method.to_s,
                         :remote_ip          => request.remote_ip)
      end
    end
  end
end

