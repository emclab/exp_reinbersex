require 'spec_helper'

module ExpReinbersex
  describe ReinbersesController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      engine_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'piece_unit', :argument_value => "t('set'), t('piece')")
    end
    
    before(:each) do
      #wf_common_action(from, to, event)
      wf = "def submit
          wf_common_action('initial_state', 'store_manager_reviewing', 'submit')
        end   
        def store_manager_approve
          wf_common_action('store_manager_reviewing', 'acct_reviewing', 'store_manager_approve')
        end 
        def store_manager_reject
          wf_common_action('store_manager_reviewing', 'initial_state', 'store_manager_reject')
        end
        def acct_approve
          wf_common_action('acct_reviewing', 'ceo_reviewing', 'acct_approve')
        end 
        def acct_reject
          wf_common_action('acct_reviewing', 'store_manager_reviewing', 'acct_reject')
        end      
        def ceo_approve
          wf_common_action('ceo_reviewing', 'approved', 'ceo_approve')
        end
        def ceo_reject
          wf_common_action('ceo_reviewing', 'rejected', 'ceo_reject')
        end
        def ceo_rewind
          wf_common_action('ceo_reviewing', 'initial_state', 'ceo_rewind')
        end
        def pay
          wf_common_action('approved', 'paid', 'pay')
        end"
      FactoryGirl.create(:engine_config, :engine_name => 'exp_reinbersex', :engine_version => nil, :argument_name => 'reinberse_wf_action_def', :argument_value => wf)
      str = 'rejected, paid'
      FactoryGirl.create(:engine_config, :engine_name => 'exp_reinbersex', :engine_version => nil, :argument_name => 'reinberse_wf_final_state_string', :argument_value => str)
      
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_pdef_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_route_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_validate_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_list_open_process_in_day', :argument_value => '45')
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns all quotes" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ExpReinbersex::Reinberse.where(:void => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:exp_reinbersex_reinberse)
        q1 = FactoryGirl.create(:exp_reinbersex_reinberse)
        get 'index', {:use_route => :exp_reinbersex}
        assigns(:reinberses).should =~ [q, q1]
      end
      
      it "should only return the quotes which belongs to exp category id" do       
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ExpReinbersex::Reinberse.where(:void => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:exp_reinbersex_reinberse)
        q1 = FactoryGirl.create(:exp_reinbersex_reinberse, :exp_category_id => 50)
        get 'index', {:use_route => :exp_reinbersex, :exp_category_id => 50}
        assigns(:reinberses).should =~ [q1]
      end
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :exp_reinbersex}
        response.should be_success
      end
    end
  
    describe "GET 'create'" do
      it "returns redirect with success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.attributes_for(:exp_reinbersex_reinberse)
        get 'create', {:use_route => :exp_reinbersex, :reinberse => q}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render new with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.attributes_for(:exp_reinbersex_reinberse, :amount => 0)
        get 'create', {:use_route => :exp_reinbersex, :reinberse => q}
        response.should render_template('new')
      end
      
    end
  
    describe "GET 'edit'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:exp_reinbersex_reinberse,:wf_state => '', :last_updated_by_id => @u.id)
        get 'edit', {:use_route => :exp_reinbersex, :id => q.id}
        response.should be_success
      end
      
      it "should redirect to previous page for an open process" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:exp_reinbersex_reinberse, :wf_state => 'store_manager_reviewing')  
        get 'edit', {:use_route => :exp_reinbersex, :id => q.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Update. Record Being Processed!")
      end
    end
  
    describe "GET 'update'" do
      it "should redirect successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:exp_reinbersex_reinberse)
        get 'update', {:use_route => :exp_reinbersex, :id => q.id, :reinberse => {:brief_note => 'for biz trip on 4/20'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:exp_reinbersex_reinberse)
        get 'update', {:use_route => :exp_reinbersex, :id => q.id, :reinberse => {:amount => 0}}
        response.should render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:exp_reinbersex_reinberse, :last_updated_by_id => @u.id)
        get 'show', {:use_route => :exp_reinbersex, :id => q.id }
        response.should be_success
      end
    end
    
    describe "GET 'list open process" do
      it "return open process only" do
        user_access = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ExpReinbersex::Reinberse.where(:void => false).order('created_at DESC')")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:exp_reinbersex_reinberse, :created_at => 50.days.ago, :wf_state => 'initial_state')  #created too long ago to show
        q1 = FactoryGirl.create(:exp_reinbersex_reinberse, :wf_state => 'ceo_reviewing')
        q2 = FactoryGirl.create(:exp_reinbersex_reinberse, :wf_state => 'initial_state')
        q3 = FactoryGirl.create(:exp_reinbersex_reinberse, :wf_state => 'rejected')  #wf_state can't be what was defined.
        get 'list_open_process', {:use_route => :exp_reinbersex}
        assigns(:reinberses).should =~ [q1, q2]
      end
    end
    
  end
end
