class UsersController < ApplicationController
  before_filter :find_user, except: [:new, :create, :index]
  
  def index
    @users = User.all
  end
  
  def show
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new user_params
    if @user.save
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes( user_params )
      redirect_to edit_user_path( @user )
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    redirect_to users_path
  end
  
  protected
  
  def find_user()
    @user = User.find params[:id]
  end
  
  private
  
  def user_params()
    params.require( :user ).permit( :first_name, 
                                    :last_name, 
                                    :email,
                                    :password,
                                    :password_confirmation )
  end
end