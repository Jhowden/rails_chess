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
    it "assigns the requested user to @user" do
      get :show, id: user
      expect( assigns( :user ) ).to eq user
    end
    
    it "renders the :index view" do
      get :show, id: user
      expect( response ).to render_template :show
    end
  end
  
  describe "GET #new" do
    before( :each ) do
      allow( User ).to receive( :new )
    end
    
    it "instantiates a new User" do
      get :new
      expect( User ).to have_received( :new )
    end
    
    it "renders the :new view" do
      get :new
      expect( response ).to render_template :new
    end
  end

  describe "POST #create" do
    let( :user ) { stub_model User }
    
    before :each do
      allow( User ).to receive( :new ).and_return user
      allow( user ).to receive( :save ).and_return true
    end
    
    context "if the create succeeds" do
      it "creates a new User" do
        post :create, user: FactoryGirl.attributes_for( :user, email: "smanspiff@example.com" )
        expect( User ).to have_received( :new ).
          with( { "first_name" => "Spaceman",
                  "last_name" => "Spiff",
                  "email" => "smanspiff@example.com",
                  "password" => "password",
                  "password_confirmation" => "password"} )
      end
      
      it do
        post :create, user: FactoryGirl.attributes_for( :user )
        expect( response ).to redirect_to user
      end
    end
    
    context "if the create fails" do
      before :each do
        allow( user ).to receive( :save ).and_return false
      end
      
      it "returns you to the 'new' page" do
        post :create, user: { first_name: nil }
        expect( response ).to render_template( "users/new" )
      end
    end
  end
end