require "rails_helper"

describe MoveSequence::NullCheckSequence do
  subject( :check_sequence ) { described_class.new }
  
  describe "#valid_move?: " do
    it "returns false" do
      expect( check_sequence.valid_move? ).to be_falsey
    end
  end
end