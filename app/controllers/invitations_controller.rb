class InvitationsController < ApplicationController
  
  def send_invite
    SendInviteSetup.new( self, params, current_user ).call
    redirect_to users_path( current_user )
  end
  
  def invitation_successfully_created( invitation )
    flash.notice = "Successfully sent invitation!"
  end
  
  def invitation_failed_to_be_created
    flash.now[:error] = "Failed to send invitation."
  end
end