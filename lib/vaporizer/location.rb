require 'vaporizer/http_client'
require 'vaporizer/validatable'

module Vaporizer
  module Location
    extend Vaporizer::HttpClient
    extend Vaporizer::Validatable

    define_httparty_request_wrapper :locations_search, :post, '/locations'
    define_httparty_request_wrapper :locations_show, :get, '/locations/:slug'

    def self.search(params = {})
      validate_presence_of([:page, :take, :latitude, :longitude], params)
      params = { body: params }
      locations_search({}, params)
    end

    def self.details(slug)
      locations_show(slug: slug)
    end
  end
end
