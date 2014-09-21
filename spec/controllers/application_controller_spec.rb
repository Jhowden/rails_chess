require 'rails_helper'

describe ApplicationController do
  let( :user ) { stub_model User }
  let( :null_user ) { stub_model NullObject::NullUser }
  
  describe "#current_user" do
    before :each do
      allow( User ).to receive( :find ).and_return user
    end
    
    it "sets a current_user" do
      session[:user_id] = 3
      controller.current_user
      expect( User ).to have_received( :find ).with( 3 )
    end
    
    context "when there is no one logged in" do
      it "does not try to find a User" do
        controller.current_user
        expect( User ).to_not have_received( :find )
      end
    end
  end
end