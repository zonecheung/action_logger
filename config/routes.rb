Rails.application.routes.draw do
  resources :action_logs, :only => [:index, :show, :destroy] do
    delete :destroy_selected, :on => :collection
  end
end

