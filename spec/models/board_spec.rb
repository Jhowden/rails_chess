require 'rails_helper'

describe Board do
  let( :board ) { described_class.new }
  
  describe "#create_board" do
    it "creates the board" do
      expect( board.create_board ).to eq( Array.new( 8 ) { |cell| Array.new( 8 ) } )
    end
  end
end