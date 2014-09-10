require 'rails_helper'

describe User, :type => :model do
	it "is valid with a first name, last name, and email" do
    expect( FactoryGirl.build( :user ) ).to be_valid
  end
  
  it "is invalid without a first name" do
    invalid_user = FactoryGirl.build( :user, first_name: nil )
    expect( invalid_user ).to be_invalid
  end
  
  it "is invalid without a last name" do
    invalid_user = FactoryGirl.build( :user, last_name: nil )
    expect( invalid_user ).to be_invalid
  end
  
  it "is invalid without an email" do
    invalid_user = FactoryGirl.build( :user, email: nil )
    expect( invalid_user ).to be_invalid
  end
  
  it "is invalid with a duplicate email" do
    user = FactoryGirl.create( :user, email: "smanspiff@example.com" )
    expect( FactoryGirl.build( :user, email: "smanspiff@example.com") ).to be_invalid
  end
  
  it "is invalid without a password" do
    invalid_user = FactoryGirl.build( :user, password: nil )
    expect( invalid_user ).to be_invalid
  end
  
  it "returns a contact’s full name as a string" do
    user = FactoryGirl.build( :user )
    expect( user.fullname ).to eq "Spaceman Spiff"
  end
end
