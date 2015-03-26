require 'spec_helper'
require 'yaml'

secrets = YAML.load_file('./secrets.yml')

describe Vaporizer::Location do

  it { expect(Vaporizer::Location).to respond_to(:locations_search) }
  it { expect(Vaporizer::Location).to respond_to(:locations_show) }
  it { expect(Vaporizer::Location).to respond_to(:locations_menu_index) }
  it { expect(Vaporizer::Location).to respond_to(:locations_reviews_index) }
  it { expect(Vaporizer::Location).to respond_to(:locations_specials_index) }

  before :all do
    Vaporizer.configure do |config|
      config.app_id = secrets['app_id']
      config.app_key = secrets['app_key']
    end

    @location_slug = 'papa-ganja'

    @non_existing_location_slug = "5d0e71bda1005d0770a4e31e1a27580"
    VCR.use_cassette('locations/non-existing-details') do
      begin
        Vaporizer::Location.details(@non_existing_location_slug)
      rescue Vaporizer::NotFound
      end
    end
  end

  describe '.search(params = {})' do
    context "valid params" do
      before :all do
        @take = 3
        VCR.use_cassette('locations/search-valid_params') do
          @locations = Vaporizer::Location.search(latitude: 47.606, longitude: -122.333, page: 0, take: @take)
        end
      end

      it 'should return a hash' do
        VCR.use_cassette('locations/search-valid_params') do
          expect(@locations.class).to be(Hash)
        end
      end

      it "should return a hash with a key named 'stores'" do
         VCR.use_cassette('locations/search-valid_params') do
          expect(@locations).to have_key('stores')
        end
      end
    end

    context "missing params" do
      it "should raise error Vaporizer::MissingParameter" do
        expect { Vaporizer::Location.search(search: '', longitude: -122.333, page: 0, take: @take) }.to raise_error(Vaporizer::MissingParameter)
      end

      it "should raise error Vaporizer::MissingParameter" do
        expect { Vaporizer::Location.search(search: '', latitude: 47.606, page: 0) }.to raise_error(Vaporizer::MissingParameter)
      end
    end
  end

  describe '.details(slug)' do
    before :all do
      VCR.use_cassette('locations/details') do
        @location = Vaporizer::Location.details(@location_slug)
      end
    end

    it 'should return a hash' do
      VCR.use_cassette('locations/details') do
        expect(@location.class).to be(Hash)
      end
    end

    it "should return the specified store" do
      VCR.use_cassette('locations/details') do
        expect(@location['slug']).to eq(@location_slug)
      end
    end

    it "should raise an error if store doesn't exist" do
      expect do
        VCR.use_cassette('locations/non-existing-details') do
          Vaporizer::Location.details(@non_existing_location_slug)
        end
      end.to raise_error(Vaporizer::NotFound)
    end
  end

  describe '.menu(slug)' do
    before :all do
      VCR.use_cassette('locations/menu') do
        @menu = Vaporizer::Location.menu(@location_slug)
      end
    end

    it 'should return a Array' do
      VCR.use_cassette('locations/menu') do
        expect(@menu.class).to be(Array)
      end
    end

    it "should raise an error if store doesn't exist" do
      expect do
        VCR.use_cassette('locations/non-existing-menu') do
          Vaporizer::Location.menu(@non_existing_location_slug)
        end
      end.to raise_error(Vaporizer::NotFound)
    end
  end

  describe '.reviews(slug, params = {})' do
    before :all do
      VCR.use_cassette('locations/reviews') do
        @reviews = Vaporizer::Location.reviews(@location_slug, { take: 1, skip: 0})
      end
    end

    it 'should return a Array' do
      VCR.use_cassette('locations/reviews') do
        expect(@reviews.class).to be(Hash)
      end
    end

    it 'should have key \'reviews\'' do
      VCR.use_cassette('locations/reviews') do
        expect(@reviews).to have_key('reviews')
      end
    end

    it "should raise an error if store doesn't exist" do
      expect do
        VCR.use_cassette('locations/non-existing-reviews') do
          Vaporizer::Location.reviews(@non_existing_location_slug, { take: 1, skip: 0})
        end
      end.to raise_error(Vaporizer::NotFound)
    end

    context "missing params" do
      it "should raise error Vaporizer::MissingParameter" do
        VCR.use_cassette('locations/reviews') do
          expect { Vaporizer::Location.reviews(@location_slug, { take: 1}) }.to raise_error(Vaporizer::MissingParameter)
        end
      end

      it "should raise error Vaporizer::MissingParameter" do
        VCR.use_cassette('locations/reviews') do
          expect { Vaporizer::Location.reviews(@location_slug, { skip: 0}) }.to raise_error(Vaporizer::MissingParameter)
        end
      end
    end
  end

  describe '.specials(slug, params = {})' do
    before :all do
      VCR.use_cassette('locations/specials') do
        @specials = Vaporizer::Location.specials(@location_slug)
      end
    end

    it 'should return a Array' do
      VCR.use_cassette('locations/specials') do
        expect(@specials.class).to be(Array)
      end
    end

    it "should raise an error if store doesn't exist" do
      expect do
        VCR.use_cassette('locations/non-existing-specials') do
          Vaporizer::Location.specials(@non_existing_location_slug)
        end
      end.to raise_error(Vaporizer::NotFound)
    end
  end
end
