require 'vaporizer/http_client'
require 'vaporizer/validatable'

module Vaporizer
  module Location
    extend Vaporizer::HttpClient
    extend Vaporizer::Validatable

    define_httparty_request_wrapper :locations_search, :post, '/locations'
    define_httparty_request_wrapper :locations_show, :get, '/locations/:slug'
    define_httparty_request_wrapper :locations_menu_index, :get, '/locations/:slug/menu'
    define_httparty_request_wrapper :locations_reviews_index, :get, '/locations/:slug/reviews'
    define_httparty_request_wrapper :locations_specials_index, :get, '/locations/:slug/specials'

    def self.search(params = {})
      validate_presence_of([:page, :take, :latitude, :longitude], params)
      params = { body: params }
      locations_search({}, params)
    end

    def self.details(slug)
      locations_show(slug: slug)
    end

    def self.menu(slug)
      locations_menu_index(slug: slug)
    end

    def self.reviews(slug, params = {})
      validate_presence_of([:take, :skip], params)
      params = { query: params }
      locations_reviews_index({ slug: slug }, params)
    end

    def self.specials(slug)
      locations_specials_index({ slug: slug})
    end
  end
end
