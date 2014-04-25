# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exp_reinbersex_reinberse, :class => 'ExpReinbersex::Reinberse' do
    amount "9.99"
    requested_by_id 1
    last_updated_by_id 1
    brief_note "MyText"
    exp_category_id 1
    wf_state "MyString"
    request_date "2014-04-23"
    approved_date '2014-04-23'
    approved false
    paid false
    paid_date "2014-04-23"
    paid_by_id 1
    void false
    requester_zone_id 1
    requester_role_id 1
  end
end
