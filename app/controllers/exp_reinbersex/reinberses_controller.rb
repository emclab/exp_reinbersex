require_dependency "exp_reinbersex/application_controller"

module ExpReinbersex
  class ReinbersesController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record
    
    def index
      @title = t('Reinbersements')
      @reinberses = params[:exp_reinbersex_reinberses][:model_ar_r]  #returned by check_access_right
      @reinberses = @reinberses.where(:exp_category_id => @exp_category_id) if @exp_category_id
      @reinberses = @reinberses.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('reinberse_index_view', 'exp_reinbersex')
    end
  
    def new
      @title = t('New Reinbersement')
      @reinberse = ExpReinbersex::Reinberse.new()
      @erb_code = find_config_const('reinberse_new_view', 'exp_reinbersex')
    end
  
    def create
      @reinberse = ExpReinbersex::Reinberse.new(params[:reinberse], :as => :role_new)
      @reinberse.last_updated_by_id = session[:user_id]
      @reinberse.requested_by_id = session[:user_id]
      @reinberse.requester_zone_id = Authentify::UsersHelper.user_zone_id_first(session[:user_id])
      @reinberse.requester_role_id = Authentify::UsersHelper.user_role_id_first(session[:user_id])
      if @reinberse.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Edit Reinbersement')
      @reinberse = ExpReinbersex::Reinberse.find_by_id(params[:id])
      @erb_code = find_config_const('reinberse_edit_view', 'exp_reinbersex')
      if @reinberse.wf_state.present? && @reinberse.current_state != :initial_state
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Update. Record Being Processed!")
      end
    end
  
    def update
      @reinberse = ExpReinbersex::Reinberse.find_by_id(params[:id])
      @reinberse.last_updated_by_id = session[:user_id]
      if @reinberse.update_attributes(params[:reinberse], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Reinbersement Info')
      @reinberse = ExpReinbersex::Reinberse.find_by_id(params[:id])
      @erb_code = find_config_const('reinberse_show_view', 'exp_reinbersex')
    end
  
    def list_open_process  
      index()
      @reinberses = return_open_process(@reinberses, find_config_const('reinberse_wf_final_state_string', 'exp_reinbersex'))  # ModelName_wf_final_state_string
    end
    
    protected
    def load_parent_record     
      @exp_category_id = params[:exp_category_id].to_i if params[:exp_category_id].present?
    end
  end
end
