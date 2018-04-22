require './docs/weather.rb'
require './docs/airport.rb'
require './docs/plane.rb'

describe Airport do
  subject(:airport) { described_class.new }
  let(:plane) { double :plane }
  let(:plane2) { double :plane }

  it { is_expected.to respond_to :weather }

  describe '#initialize' do
    it 'should have a default capacity of DEFAULT_CAPACITY planes' do
      expect(airport.capacity).to eq Airport::DEFAULT_CAPACITY
    end
  end

  describe '#capacity' do
    it 'should allow the default capacity to be overriden' do
      airport.capacity = 2
      expect(airport.capacity).to eq 2
    end
  end

  describe '#stationed_planes' do
    it 'should only inlcude planes' do
      expect(airport.stationed_planes).to all(be_instance_of Plane)
    end
  end

  describe '#land' do
    it 'lands a plane' do
      allow(airport.weather).to receive(:stormy?) { false }
      airport.land(plane)
      expect(airport.stationed_planes).to eq [plane]
    end
    it 'raises an error when the airport is full' do
      allow(airport).to receive(:full?) { true }
      allow(airport.weather).to receive(:stormy?) { false }
      expect { airport.land(plane) }.to raise_error "Airport full"
    end
    it 'raises an error when the weather is stormy' do
      allow(airport.weather).to receive(:stormy?) { true }
      expect { airport.land(Plane.new) }.to raise_error "Weather too stormy to land"
    end
    it 'raises an error if the plane has already landed' do
      allow(airport.weather).to receive(:stormy?) { false }
      airport.land(plane)
      expect { airport.land(plane) }.to raise_error "That plane has already landed"
    end
  end

  describe '#take_off' do
    it 'instructs a plane to take off' do
      allow(airport.weather).to receive(:stormy?) { false }
      airport.land(plane)
      expect(airport.take_off(plane)).to eq plane
    end
    it 'removes the plane from the airport' do
      allow(airport.weather).to receive(:stormy?) { false }
      airport.land(plane)
      airport.take_off(plane)
      expect(airport.stationed_planes).to eq []
    end
    it 'raises an error when the plane is not stationed in the aiport' do
      allow(airport.weather).to receive(:stormy?) { false }
      allow(airport).to receive(:include?) { false }
    end
    it 'raises an error when the weather is stormy' do
      allow(airport.weather).to receive(:stormy?) { true }
      expect { airport.take_off(plane) }.to raise_error "Weather too stormy to take off"
    end
  end
end
