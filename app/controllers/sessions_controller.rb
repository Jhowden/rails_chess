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
  
  def logout
    session.clear
    redirect_to :root
  end
  
  private 
  
  def login_params()
    params.require( :login ).permit( :email, :password )
  end
end