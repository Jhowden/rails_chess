class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email
  
  def fullname
    [first_name, last_name].join( " " )
  end
end
