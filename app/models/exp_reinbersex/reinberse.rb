module ExpReinbersex
  require 'workflow'
  class Reinberse < ActiveRecord::Base
    include Workflow
    workflow_column :wf_state
    
    workflow do
      wf = Authentify::AuthentifyUtility.find_config_const('reinberse_wf_pdef', 'exp_reinbersex')
      if Authentify::AuthentifyUtility.find_config_const('wf_pdef_in_config') == 'true' && wf.present?
        eval(wf) 
      elsif Rails.env.test?  
        state :initial_state do
          event :submit, :transitions_to => :store_manager_reviewing
        end
        state :store_manager_reviewing do
          event :store_manager_approve, :transitions_to => :acct_reviewing
          event :store_manager_reject, :transitions_to => :initial_state
        end
        state :acct_reviewing do
          event :acct_approve, :transitions_to => :ceo_reviewing
          event :acct_reject, :transitions_to => :store_manager_reviewing
        end
        state :ceo_reviewing do
          event :ceo_approve, :transitions_to => :approved
          event :ceo_reject, :transitions_to => :rejected
          event :ceo_rewind, :transitions_to => :initial_state
        end
        state :approved do
          event :pay, :transitions_to => :paid
        end
        state :paid
        state :rejected
        
      end
    end
    
    attr_accessor :exp_category_name, :last_updated_by_name, :approved_noupdate, :paid_noupdate, :requested_by_name, :requester_zone_name, :requester_role_name,
                  :void_noupdate, :wf_comment, :id_noupdate
    attr_accessible :amount, :approved, :approved_date, :brief_note, :exp_category_id, :last_updated_by_id, :paid, :paid_by_id, :paid_date, :request_date, 
                    :requested_by_id, :requester_role_id, :requester_zone_id, :void, :wf_state,
                    :as => :role_new
    attr_accessible :amount, :approved, :approved_date, :brief_note, :exp_category_id, :paid, :paid_by_id, :paid_date, :request_date, 
                    :requester_role_id, :requester_zone_id, :void, :wf_state,
                    :wf_comment, :id_noupdate, :exp_category_name, :last_updated_by_name, :approved_noupdate, :paid_noupdate, :requested_by_name, :requester_zone_name, :requester_role_name,
                    :void_noupdate,
                    :as => :role_update
    
    attr_accessor :start_date_s, :end_date_s, :exp_category_id_s, :paid_date_s, :time_frame_s, :requested_by_id_s, :requester_zone_id_s, 
                  :requester_role_id_s, :approved_s, :void_s, :paid_by_id_s, :approved_date_s

    attr_accessible :start_date_s, :end_date_s, :exp_category_id_s, :paid_date_s, :time_frame_s, :requested_by_id_s, :requester_zone_id_s, 
                    :requester_role_id_s, :approved_s, :void_s, :paid_by_id_s, :approved_date_s,
                    :as => :role_search_stats
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :paid_by, :class_name => 'Authentify::User'
    belongs_to :requested_by, :class_name => 'Authentify::User'
    belongs_to :requester_zone, :class_name => 'Authentify::Zone'
    belongs_to :requester_role, :class_name => 'Authentify::RoleDefinition'
    belongs_to :exp_category, :class_name => 'Commonx::MiscDefinition'
    
    validates :amount, :presence => true,
                       :numericality => {:greater_than => 0, :message => I18n.t('Amount > 0.00')} 
    validates_presence_of :request_date, :brief_note 
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'exp_reinbersex')
      eval(wf) if wf.present?
    end        
                                          
    #for workflow input validation  
    validate :validate_wf_input_data, :if => 'wf_state.present?' 
    
    def validate_wf_input_data
      wf = Authentify::AuthentifyUtility.find_config_const('validate_reinberse_' + self.wf_state, 'exp_reinbersex')
      if Authentify::AuthentifyUtility.find_config_const('wf_validate_in_config') == 'true' && wf.present? 
        eval(wf) 
      end
    end           
    
  end
end
