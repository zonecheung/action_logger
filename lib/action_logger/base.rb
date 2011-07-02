module ActionLogger
  class Base
    def self.included(base)
      base.send :extend, ClassMethods
    end
   
    module ClassMethods
      def log_request(options = {})
        if (options[:only].blank? || convert_options(options[:only]) { |x| x.to_s }.include?(params[:action])) &&
           (options[:except].blank? || ! convert_options(options[:except]) { |x| x.to_s }.include?(params[:action])) &&
           (options[:method].blank? || convert_options(options[:method]) { |x| x.to_s.uppercase }.include?(request.method))
          before_filter :log_current_request_action
        end
      end

      private

      def convert_options(options, &block)
        if options.is_a?(Array)
          options.map(&block)
        else
          [block.call(options)]
        end
      end
    end

    def log_current_request_action
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

