require 'spec_helper'

describe "LinkTests" do
  describe "GET /exp_reinbersex_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
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
      FactoryGirl.create(:engine_config, :engine_name => 'exp_reinbersex', :engine_version => nil, :argument_name => 'reinberse_pay_inline', 
                         :argument_value => "<%= f.input :paid_date, :label => t('Paid Date') , :as => :string %>
                                             <%= f.input :paid_by_id, :as => :hidden, :input_html => {:value => session[:user_id]}%>
                                             <%= f.input :paid, :as => :hidden, :input_html => {:value => true} %>")
      FactoryGirl.create(:engine_config, :engine_name => 'exp_reinbersex', :engine_version => nil, :argument_name => 'validate_reinberse_pay', 
                         :argument_value => "validates :paid_date, :paid, :presence => true ")   
                         
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_pdef_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_route_in_config', :argument_value => nil)
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_validate_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_list_open_process_in_day', :argument_value => '45')
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      exp_category = FactoryGirl.create(:commonx_misc_definition, :name => 'exp_category', :for_which => 'exp_category')
      
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ExpReinbersex::Reinberse.where(:void => false).order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      #  
      user_access = FactoryGirl.create(:user_access, :action => 'event_action', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ExpReinbersex::Reinberse.where(:void => false).order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'submit', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'pay', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'store_manager_approve', :resource =>'exp_reinbersex_reinberses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
    
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works! (now write some real specs)" do
      task = FactoryGirl.create(:exp_reinbersex_reinberse,:paid_by_id => nil, :requested_by_id => @u.id)
      visit reinberses_path
      #save_and_open_page
      page.should have_content('Reinbersements')
      page.should have_content('Initial State')  #for workflow
      page.should have_content('Submit Reinbersement')
      click_link 'Edit'
      #save_and_open_page
      page.should have_content('Edit Reinbersement')
      #save_and_open_page
      fill_in 'reinberse_amount', :with => 230
      click_button "Save"
      #bad data
      visit reinberses_path
      click_link 'Edit'
      fill_in 'reinberse_request_date', :with => nil
      click_button "Save"
      #save_and_open_page
      
      #show
      visit reinberses_path
      #save_and_open_page
      click_link task.id.to_s
      #save_and_open_page
      page.should have_content('Reinbersement Info')
      
      #new
      visit new_reinberse_path()
      #save_and_open_page
      page.should have_content('New Reinbersement')
      fill_in 'reinberse_request_date', :with => '2014-04-11'
      fill_in 'reinberse_amount', :with =>  230
      fill_in 'reinberse_brief_note', :with => 'for biz trip'
      select('exp_category', :from => 'reinberse_exp_category_id')
      click_button 'Save'
      #save_and_open_page
      #bad data
      visit new_reinberse_path()
      fill_in 'reinberse_request_date', :with => '2014-04-11'
      fill_in 'reinberse_amount', :with =>  230
      fill_in 'reinberse_brief_note', :with => ''
      select('exp_category', :from => 'reinberse_exp_category_id')
      click_button 'Save'
      #save_and_open_page
      
    end
    
    it "should create a reinbersement with initial stat and submit" do
      visit reinberses_path  #allow to redirect after save new below
      save_and_open_page
      click_link 'New Reinberse'
      save_and_open_page
      page.should have_content('New Reinbersement')
      fill_in 'reinberse_request_date', :with => '2014-04-11'
      fill_in 'reinberse_amount', :with =>  230
      fill_in 'reinberse_brief_note', :with => 'for biz trip'
      select('exp_category', :from => 'reinberse_exp_category_id')
      click_button 'Save'
      save_and_open_page
      
      #
      visit reinberses_path()
      #save_and_open_page
      page.should have_content('Submit Reinbersement')
      click_link 'Submit Reinbersement'
      save_and_open_page
      fill_in 'reinberse_wf_comment', :with => 'this is first submission'
      click_button 'Save'
      save_and_open_page
    end
    
    it "work for workflow from approved to pay" do
      task = FactoryGirl.create(:exp_reinbersex_reinberse,:paid_by_id => nil, :wf_state => 'approved')
      visit reinberses_path
      save_and_open_page
      click_link 'Pay'
      #save_and_open_page
      fill_in 'reinberse_wf_comment', :with => 'this line tests workflow'
      fill_in 'reinberse_paid_date', :with => Date.today - 2.days
      #save_and_open_page
      click_button 'Save'
      #
      visit reinberses_path
      #save_and_open_page
      click_link 'Open Process'
      page.should have_content('Reinbersements')
      
      visit reinberses_path
      click_link task.id.to_s
      #save_and_open_page
      page.should have_content('this line tests workflow')
      page.should have_content((Date.today - 2.days).to_s.gsub('-', '/'))
    end
    
  end
end
