require "rails_helper"

describe NullObject::NullUser do
  let( :null_user ) { described_class.new }
  describe "#authenticate" do
    it "returns false" do
      expect( null_user.authenticate( "password" ) ).to be_falsey
    end
  end
end