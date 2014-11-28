class UsersController < ApplicationController
  before_filter :find_user, except: [:index]
  
  def index
    @users = User.all
  end
  
  def show
    @sent_invitations = @user.sent_invitations
    @received_invitations = @user.received_invitations
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