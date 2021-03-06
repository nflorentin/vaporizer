require 'vaporizer/http_client'
require 'vaporizer/validatable'

module Vaporizer
  module Strain
    extend Vaporizer::HttpClient
    extend Vaporizer::Validatable

    define_httparty_request_wrapper :strains_search, :post, '/strains'
    define_httparty_request_wrapper :strains_show, :get, '/strains/:slug'
    define_httparty_request_wrapper :strains_reviews_index, :get, '/strains/:slug/reviews'
    define_httparty_request_wrapper :strains_reviews_show, :get, '/strains/:slug/reviews/:review_id'
    define_httparty_request_wrapper :strains_photos_index, :get, '/strains/:slug/photos'
    define_httparty_request_wrapper :strains_availabilities_index, :get, '/strains/:slug/availability'

    def self.search(params = {})
      validate_presence_of([:page, :take], params)
      params = { body: params.to_json }
      strains_search({}, params)
    end

    def self.details(slug)
      strains_show(slug: slug)
    end

    def self.reviews(slug, params = {})
      validate_presence_of([:page, :take], params)
      params = { query: params }
      strains_reviews_index({ slug: slug }, params)
    end

    def self.review_details(slug, review_id)
      strains_reviews_show({ slug: slug, review_id: review_id })
    end

    def self.photos(slug, params = {})
      validate_presence_of([:page, :take], params)
      params = { query: params }
      strains_photos_index({ slug: slug }, params)
    end

    def self.availabilities(slug, params = {})
      validate_presence_of([:lat, :lon], params)
      params = { query: params }
      strains_availabilities_index({ slug: slug }, params)
    end
  end
end
