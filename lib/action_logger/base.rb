module ActionLogger
  module Base
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

