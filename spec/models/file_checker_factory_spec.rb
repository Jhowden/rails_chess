require "rails_helper"

describe FileCheckerFactory do
  let( :position ) { Position.new( "a", 4 ) }

  before :each do
    stub_const( "PreviousFileLocation", Class.new )
    allow( PreviousFileLocation ).to receive( :check_space_adjacent_space )

    stub_const( "NextFileLocation", Class.new )
    allow( NextFileLocation ).to receive( :check_space_adjacent_space )
  end

  describe ".create_for" do
    it "creates a new PreviousFileLocation" do
      described_class.create_for( position, :previous )
      expect( PreviousFileLocation ).to have_received( :check_space_adjacent_space ).
        with( position )
    end

    it "creates a new NextFileLocation" do
      described_class.create_for( position, :next )
      expect( NextFileLocation ).to have_received( :check_space_adjacent_space ).
        with( position )
    end

    it "raises a NameError is the Klass does NOT exist" do
      expect{ described_class.create_for( position, :forward ) }.to raise_error NameError
    end
  end
end