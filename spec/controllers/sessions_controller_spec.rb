require 'rails_helper'

describe SessionsController do
  let( :user ) { FactoryGirl.create( :user, email: "smanspiff@example.com" ) }
  let( :null_user ) { stub_model NullObject::NullUser }
   
  before :each do
    allow( User ).to receive( :find_by_email ).and_return user
    allow( user ).to receive( :authenticate ).and_return true
    @params = { login: { email: user.email, password: user.password } }
  end
  
  describe "GET #login" do
    it "renders the login template" do
      get :login
      expect( response ).to render_template "login"
    end
  end
   
  describe "POST #login_user" do
    it "redirects the user to the user_show page when logged in" do
      post :login_user, @params
      expect( response ).to redirect_to users_path
    end

    it "finds the User" do
      post :login_user, @params
      expect( User ).to have_received( :find_by_email ).with( @params[:login].stringify_keys["email"] )
    end

    it "authenticates the user" do
      post :login_user, @params
      expect( user ).to have_received( :authenticate ).with( @params[:login].stringify_keys["password"] )
    end

    it "sets the session_id to the current user" do
      post :login_user, @params
      expect( session[:user_id] ).to eq( user.id )
    end
    
    it "sets a flash message" do
      post :login_user, @params
      expect( flash.notice ).to match /Successfully logged/
    end

    context "when a user fails to login" do
      before :each do
        allow( user ).to receive( :authenticate ).and_return false
      end

      it "renders the login page" do
        post :login_user, @params
        expect( response ).to render_template( "sessions/login" )
      end
      
      it "sets a flash message" do
        post :login_user, @params
        expect( flash[:error] ).to match /Invalid/
      end
    end

    context "when the User can't be found in the database" do
      before :each do
        allow( User ).to receive( :find_by_email ).and_return nil
        allow( NullObject::NullUser ).to receive( :new ).and_return null_user
        allow( null_user ).to receive( :authenticate ).and_return false
      end

      it "returns a NullUser" do
        get :login_user, @params
        expect( NullObject::NullUser ).to have_received( :new )
      end

      it "tries to authenticate the null_user" do
        get :login_user, @params
        expect( null_user ).to have_received( :authenticate ).with( @params[:login].stringify_keys["password"] )
      end

      it "renders the login page" do
        get :login_user, @params
        expect( response ).to render_template "login"
      end
    end
  end
  
  describe "GET #register" do
    before( :each ) do
      allow( User ).to receive( :new )
    end
    
    it "instantiates a new User" do
      get :register
      
      expect( User ).to have_received( :new )
    end
    
    it "renders the :register template" do
      get :register
      
      expect( response ).to render_template( "sessions/register" )
    end
  end
  
  describe "POST #register_user" do
    let( :user ) { stub_model User }
    
    before :each do
      allow( User ).to receive( :new ).and_return user
      allow( user ).to receive( :save ).and_return true
    end
    
    context "if the create succeeds" do
      it "creates a new User" do
        post :register_user, user: FactoryGirl.attributes_for( :user, email: "smanspiff@example.com" )
        expect( User ).to have_received( :new ).
          with( { "first_name" => "Spaceman",
                  "last_name" => "Spiff",
                  "email" => "smanspiff@example.com",
                  "password" => "password",
                  "password_confirmation" => "password"} )
      end
      
      it do
        post :register_user, user: FactoryGirl.attributes_for( :user )
        expect( response ).to redirect_to user
      end
      
      it "sets a flash message" do
        post :register_user, user: FactoryGirl.attributes_for( :user )
        expect( flash.notice ).to match( /User successfully/ )
      end
      
      it "sets the session[:user_id] to the current user" do
        post :register_user, user: FactoryGirl.attributes_for( :user )
        expect( session[:user_id] ).to eq user.id
      end
    end
    
    context "when the create fails" do
      before :each do
        allow( user ).to receive( :save ).and_return false
      end
      
      it "returns you to the 'register' page" do
        post :register_user, user: { first_name: nil }
        expect( response ).to render_template( "sessions/register" )
      end
      
      it "sets a flash message" do
        post :register_user, user: { first_name: nil }
        expect( flash[:error] ).to match( /Could not/ )
      end
    end
  end
  
  describe "POST #logout" do
    it "redirects user user to the welcome page when logging out" do
      post :logout
      expect( response ).to redirect_to :root
    end
    
    it "clears the session" do
      session[:user_id] = 5
      post :logout
      expect( session ).to be_empty
    end
  end
end