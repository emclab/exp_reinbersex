ExpReinbersex::Engine.routes.draw do
  resources :reinberses do
    collection do
      get :search
      get :search_results
      get :stats
      get :stats_results    
    end
    
#=begin    
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('reinberse_wf_route', 'exp_reinbersex')
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    elsif Rails.env.test?
      member do
        get :event_action
        put :submit
        put :store_manager_approve
        put :store_manager_reject
        put :acct_approve
        put :acct_reject
        put :ceo_approve
        put :ceo_reject
        put :ceo_rewind
        put :pay
        
      end
      
      collection do
        get :list_open_process
      end
    end
#=end
  end

end
