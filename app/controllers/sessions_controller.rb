class SessionsController < ApplicationController
  def login
  end
  
  def login_user
    user = User.find_by_email( login_params[:email] ) || NullObject::NullUser.new
    if user.authenticate( login_params[:password] )
      session[:user_id] = user.id
      flash.notice = "Successfully logged in."
      redirect_to users_path
    else
      flash[:error] = "Invalid username or password."
      render :login
    end
  end
  
  def register
    @User = User.new
  end
  
  def register_user
    @User = User.new registration_params
    if @User.save
      session[:user_id] = @User.id
      flash.notice = "User successfully created"
      redirect_to @User
    else
      flash.now[:error] = "Could not register user"
      render :register
    end
  end
  
  def logout
    session.clear
    redirect_to :root
  end
  
  private 
  
  def login_params()
    params.require( :login ).permit( :email, :password )
  end
  
  def registration_params()
    params.require( :user ).permit( :first_name, 
                                    :last_name, 
                                    :email,
                                    :password,
                                    :password_confirmation )
  end
end