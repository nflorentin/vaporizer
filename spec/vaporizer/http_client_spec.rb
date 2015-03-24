require 'spec_helper'

describe Vaporizer::HttpClient do
  before :all do
    @api = Module.new
    @api.extend(Vaporizer::HttpClient)
  end

  describe 'get_route_params_values(url_params, params_given)' do
    it "should return empty array if there are not url params" do
      expect(@api.get_route_params_values([],{})).to eq([])
    end
  end

  describe 'get_route_params_values(url_params, params_given)' do
    context "there are no missing params" do
      it "should return values of params values" do
        expect(@api.get_route_params_values([:strain_id], { strain_id: '123' })).to eq(['123'])
      end
    end

    context "there is missing param" do
      it "should raise an error" do
        expect { @api.get_route_params_values([:strain_id], {}) }.to raise_error(Vaporizer::MissingPathParameter)
      end
    end
  end

  describe "call define_httparty_request_wrapper at class level" do
    before :all do
      @api.instance_eval do
        define_httparty_request_wrapper :test_method, :get, '/testUrl/:test'
      end
    end

    it "should define the method" do
      expect(@api).to respond_to(:test_method)
    end
  end
end
