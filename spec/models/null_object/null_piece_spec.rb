require "rails_helper"

describe NullObject::NullPiece do
  let(:null_piece) { described_class.new }

  describe "#team" do
    it "returns nil" do
      expect( null_piece.team ).to be_nil
    end
  end

  describe "#move_counter" do
    it "returns nil" do
      expect( null_piece.move_counter ).to be_nil
    end
  end
end