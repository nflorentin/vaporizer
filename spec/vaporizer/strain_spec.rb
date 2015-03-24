require 'spec_helper'
require 'yaml'

secrets = YAML.load_file('./secrets.yml')

describe Vaporizer::Strain do

  it { expect(Vaporizer::Strain).to respond_to(:strains_search) }
  it { expect(Vaporizer::Strain).to respond_to(:strains_show) }
  it { expect(Vaporizer::Strain).to respond_to(:strains_reviews_index) }
  it { expect(Vaporizer::Strain).to respond_to(:strains_reviews_show) }
  it { expect(Vaporizer::Strain).to respond_to(:strains_photos_index) }
  it { expect(Vaporizer::Strain).to respond_to(:strains_availabilities_index) }

  before :all do
    Vaporizer.configure do |config|
      config.app_id = secrets['app_id']
      config.app_key = secrets['app_key']
    end

    @non_existing_strain_slug = "14800da40dbdb5115d3e02168972b845"
    VCR.use_cassette('non-existing-strain-details') do
      begin
        Vaporizer::Strain.details(@non_existing_strain_slug)
      rescue Vaporizer::NotFound
      end
    end

    VCR.use_cassette('non-existing-strain-reviews') do
      begin
        Vaporizer::Strain.reviews(@non_existing_strain_slug, page: 0, take: 1)
      rescue Vaporizer::NotFound
      end
    end
  end

  describe '.search(params = {})' do
    context "valid params" do
      before :all do
        @take = 10
        VCR.use_cassette('search-valid_params') do
          @strains = Vaporizer::Strain.search({ search: '', page: 0, take: @take })
        end
      end

      it 'should return a hash' do
        VCR.use_cassette('search-valid_params') do
          expect(@strains.class).to be(Hash)
        end
      end

      it "should return a hash with a key named 'Strains'" do
         VCR.use_cassette('search-valid_params') do
          expect(@strains).to have_key('Strains')
        end
      end

      it "should return the right number of strains" do
        VCR.use_cassette('search-valid_params') do
          expect(@strains['Strains'].size).to eq(@take)
        end
      end
    end

    context "missing params" do
      it "should raise error Vaporizer::MissingParameter" do
        expect { Vaporizer::Strain.search({ search: '', page: 0 }) }.to raise_error(Vaporizer::MissingParameter)
      end

      it "should raise error Vaporizer::MissingParameter" do
        expect { Vaporizer::Strain.search({ search: '', take: 0 }) }.to raise_error(Vaporizer::MissingParameter)
      end
    end
  end

  describe '.details(slug)' do
    before :all do
      VCR.use_cassette('details') do
        @strain = Vaporizer::Strain.details('la-confidential')
      end
    end

    it 'should return a hash' do
      VCR.use_cassette('details') do
        expect(@strain.class).to be(Hash)
      end
    end

    it "should return the specified strain" do
      VCR.use_cassette('details') do
        expect(@strain['slug']).to eq('la-confidential')
      end
    end

    it "should raise an error if strain doesn't exist" do
      expect do
        VCR.use_cassette('non-existing-strain-details') do
          Vaporizer::Strain.details(@non_existing_strain_slug)
        end
      end.to raise_error(Vaporizer::NotFound)
    end
  end

  describe '.reviews(slug, params = {})' do
    context "valid params" do
      before :all do
        @take = 7
        @page = 0
        VCR.use_cassette('reviews') do
          @strains = Vaporizer::Strain.reviews('la-confidential', { page: @page, take: @take })
        end
      end

      it 'should return a hash' do
        VCR.use_cassette('reviews') do
          expect(@strains.class).to be(Hash)
        end
      end

      it "should return a hash with a key named 'reviews'" do
         VCR.use_cassette('reviews') do
          expect(@strains).to have_key('reviews')
        end
      end

      it "should return the right number of strains" do
        VCR.use_cassette('reviews') do
          expect(@strains['reviews'].size).to eq(@take)
        end
      end

      it "should give paging context corresponding to sent params" do
        VCR.use_cassette('reviews') do
          expect(@strains['pagingContext']['PageIndex']).to eq(@page)
        end
      end

      it "should give paging context corresponding to sent params" do
        VCR.use_cassette('reviews') do
          expect(@strains['pagingContext']['PageSize']).to eq(@take)
        end
      end

      it "should raise an error if strain doesn't exist" do
        expect do
          VCR.use_cassette('non-existing-strain-reviews') do
            Vaporizer::Strain.reviews(@non_existing_strain_slug, { page: 0, take: 1 })
          end
        end.to raise_error(Vaporizer::NotFound)
      end
    end

    context "missing params" do
      it "should raise error Vaporizer::MissingParameter" do
        expect { Vaporizer::Strain.reviews('la-confidential', { take: 2 }) }.to raise_error(Vaporizer::MissingParameter)
      end

      it "should raise error Vaporizer::MissingParameter" do
        expect { Vaporizer::Strain.reviews('la-confidential', { page: 1 }) }.to raise_error(Vaporizer::MissingParameter)
      end
    end
  end

end
