require 'spec_helper'

module ExpReinbersex
  describe Reinberse do
    it "should be OK" do
      c = FactoryGirl.build(:exp_reinbersex_reinberse)
      c.should be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:exp_reinbersex_reinberse, :amount=> nil)
      c.should_not be_valid
    end
    
    it "should reject 0 name" do
      c = FactoryGirl.build(:exp_reinbersex_reinberse, :amount=> 0)
      c.should_not be_valid
    end
    
    it "should reject nil request date" do
      c = FactoryGirl.build(:exp_reinbersex_reinberse, :request_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil brief note" do
      c = FactoryGirl.build(:exp_reinbersex_reinberse, :brief_note => nil)
      c.should_not be_valid
    end
  end
end
