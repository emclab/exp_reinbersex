class CreateExpReinbersexReinberses < ActiveRecord::Migration
  def change
    create_table :exp_reinbersex_reinberses do |t|
      t.decimal :amount, :precision => 10, :scale => 2
      t.integer :requested_by_id
      t.integer :last_updated_by_id
      t.text :brief_note
      t.integer :exp_category_id
      t.string :wf_state
      t.date :request_date
      t.date :approved_date
      t.boolean :approved, :default => false
      t.boolean :paid, :default => false
      t.date :paid_date
      t.integer :paid_by_id
      t.boolean :void, :default => false
      t.integer :requester_zone_id  #record the zone id as it was
      t.integer :requester_role_id   # record the role id as it was

      t.timestamps
    end
    
    add_index :exp_reinbersex_reinberses, :requested_by_id
    add_index :exp_reinbersex_reinberses, :requester_zone_id
    add_index :exp_reinbersex_reinberses, :requester_role_id
    add_index :exp_reinbersex_reinberses, :exp_category_id
    add_index :exp_reinbersex_reinberses, :wf_state
    add_index :exp_reinbersex_reinberses, :paid_by_id
    add_index :exp_reinbersex_reinberses, :paid
    add_index :exp_reinbersex_reinberses, :void
    add_index :exp_reinbersex_reinberses, :request_date
    add_index :exp_reinbersex_reinberses, :paid_date
  end
end
