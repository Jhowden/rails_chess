class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email
  
  has_many :invitations, foreign_key: "sender_id"
  has_many :invitations, foreign_key: "receiver_id"
  
  def fullname
    [first_name, last_name].join( " " )
  end
end
