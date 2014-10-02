require 'rails_helper'

describe UsersController do
  let( :user ) { FactoryGirl.create( :user ) }
  
  describe "GET #index" do
    it "lists all of the users" do
      get :index
      expect( assigns( :users ) ).to eq [user]
    end
    
    it "renders the :index view" do
      get :index
      expect( response ).to render_template :index
    end
  end
  
  describe "GET #show" do
    before :each do
      allow( User ).to receive( :find ).and_return user
      allow( user ).to receive( :invitations )
      session[:user_id] = user.id
    end
    
    it "renders the :show view" do
      get :show, id: user
      expect( response ).to render_template :show
    end
    
    it "looks up the user" do
      get :show, id: user
      expect( User ).to have_received( :find ).with( user.id.to_s )
    end
    
    it "looks up the games the User is in" do
      allow( user ).to receive( :invitations )
      
      get :show, id: user
      
      expect( user ).to have_received( :invitations )
    end
    
    after :each do
      session.clear
    end
  end
  
  describe "GET #edit" do
    let( :user ) { stub_model User }
    
    before :each do
      allow( User ).to receive( :find ).and_return user
    end
    
    it "finds the specified User" do
      get :edit,  id: 4
      expect( User ).to have_received( :find ).with "4"
    end
    
    it "renders the 'edit' page" do
      get :edit, id: 4
      expect( response ).to render_template( "users/edit" )
    end
  end
  
  describe "PUT #update" do
    before :each do
      allow( User ).to receive( :find ).and_return user
      allow( user ).to receive( :update_attributes ).and_return true
      @params = { id: user.id, user: { first_name: "Jon" } }
    end
    
    it "redirects back to the edit page" do
      put :update, @params
      expect( response ).to redirect_to( edit_user_path( user ) )
    end
    
    it "finds the given User" do
      put :update, @params
      
      expect( User ).to have_received( :find ).with( user.id.to_s )
    end
    
    it "updates the content of the User" do
      put :update, @params
      expect( user ).to have_received( :update_attributes ).
        with( @params[:user].stringify_keys )
    end
    
    context "if the update fails" do
      before :each do
        allow( User ).to receive( :find ).and_return user
        allow( user ).to receive( :update_attributes ).and_return false
      end
      
      it "renders the edit page" do
        params = { id: user.id, user: { first_name: nil } }
        put :update, params
        expect( response ).to render_template( "users/edit" )
      end
    end
  end
  
  describe "DELETE #destroy" do
    let( :user ) { stub_model User }
    
    before :each do
      allow( User ).to receive( :find ).and_return user
      allow( user ).to receive( :destroy )
    end
    
    it "redirects to the 'index' page" do
      delete :destroy, id: 4
      expect( response ).to redirect_to( users_path )
    end
    
    it "finds the given User" do
      delete :destroy, id: 4
      expect( User ).to have_received( :find ).with "4"
    end
    
    it "destroys the User" do
      delete :destroy, id: 4
      expect( user ).to have_received( :destroy )
    end
  end
end