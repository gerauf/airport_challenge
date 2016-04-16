require 'airport'

# As an air traffic controller
# So I can get passengers to a destination
# I want to instruct a plane to land at an airport and confirm that it has landed

# As an air traffic controller
# So I can get passengers on the way to their destination
# I want to instruct a plane to take off from an airport and confirm that it is no longer in the airport

# As an air traffic controller
# To ensure safety
# I want to prevent takeoff when weather is stormy
#
# As an air traffic controller
# To ensure safety
# I want to prevent landing when weather is stormy

# As an air traffic controller
# To ensure safety
# I want to prevent landing when the airport is full

describe Airport do

  it {is_expected.to respond_to(:land).with(1).argument}
  it {is_expected.to respond_to(:take_off)}
  it {is_expected.to respond_to(:planes_in_airport)}


  let(:plane) {double :plane, land: nil, take_off: nil}

  it 'airports have a default capacity of 25 planes' do
    expect(Airport::DEFAULT_CAPACITY).to eq 25
  end

  describe "#land" do
    it "plane will recieve a call to land when weather is fine" do
      allow(Weather).to receive(:sunny?).and_return(true)
      expect(plane).to receive(:land)
      subject.land(plane)
    end

    it 'confirms that a plane has landed when weather is fine' do
      allow(Weather).to receive(:sunny?).and_return(true)
      expect(subject.land(plane)).to eq "That was a bumpy landing sir"
    end

    it "won't land if not sunny" do
      allow(Weather).to receive(:sunny?).and_return(false)
      expect {subject.land(plane)}.to raise_error "Not in this weather mate"
    end

    it "planes can't land when the airport is full" do
      allow(Weather).to receive(:sunny?).and_return(true)
      Airport::DEFAULT_CAPACITY.times {subject.land(plane)}
      expect{subject.land(plane)}.to raise_error("No room here mate")
    end

  end

  describe "#take_off" do
    it 'empty airport will raise an error' do
      expect {subject.take_off}.to raise_error("No planes here mate")
    end

    it "plane will recieve a call to take_off when weather is fine" do
      allow(Weather).to receive(:sunny?).and_return(true)
      subject.land(plane)
      expect(plane).to receive(:take_off)
      subject.take_off
    end

    it 'confirms that a plane has left the airport when weather is fine' do
      allow(Weather).to receive(:sunny?).and_return(true)
      subject.land(plane)
      expect(subject.take_off).to eq "Don't forget to send a postcard"
    end

    it 'no take off in bad weather' do
      allow(Weather).to receive(:sunny?).and_return(true)
      subject.land(plane)
      allow(Weather).to receive(:sunny?).and_return(false)
      expect{subject.take_off}.to raise_error "Not in this weather mate"
    end

    it 'plane leaves the airport' do
      allow(Weather).to receive(:sunny?).and_return(true)
      subject.land(plane)
      subject.take_off
      expect(subject.planes_in_airport).to eq []
    end
  end

  describe "#planes_in_airport" do
    it 'a new airport has no planes' do
      expect(subject.planes_in_airport).to eq []
    end

    it 'list all landed planes' do
      allow(Weather).to receive(:sunny?).and_return(true)
      subject.land(plane)
      expect(subject.planes_in_airport).to eq [plane]
    end
  end



end
