require 'json'
require 'vaporizer/requester'

module Vaporizer
  module Strain
    extend Vaporizer::Requester

    define_httparty_request_wrapper :strains_search, :post, '/strains', 'Accept-Encoding' => 'gzip, deflate'
    define_httparty_request_wrapper :strains_show, :get, '/strains/:slug'
    define_httparty_request_wrapper :strains_reviews_index, :get, '/strains/:slug/reviews'
    define_httparty_request_wrapper :strains_reviews_show, :get, '/strains/:slug/reviews/:review_id'
    define_httparty_request_wrapper :strains_photos_index, :get, '/strains/:slug/photos'
    define_httparty_request_wrapper :strains_availabilities_index, :get, '/strains/:slug/availability'


    def self.search(params = {})
      validate_presence_of([:page, :take], params)
      params = { body: params.to_json }
      response = strains_search({}, params)
      JSON.parse(response.body)
    end

    def self.details(slug)
      response = strains_show(slug: slug)
      JSON.parse(response.body)
    end

    def self.reviews(slug, query_params = {})
      params = { page: 0, take: 10 }.merge(query_params)
      params = { query: params }
      response = strains_reviews_index({ slug: slug}, params)
      handle_parser_error do
        JSON.parse(response.body)
      end
    end

    def self.review_details(slug, review_id)
      response = strains_reviews_show({ slug: slug, review_id: review_id })
      handle_parser_error do
        JSON.parse(response.body)
      end
    end

    def self.photos(slug, query_params = {})
      params = { page: 0, take: 10 }.merge(query_params)
      params = { query: params }
      response = strains_photos_index({ slug: slug}, params)
      handle_parser_error do
        JSON.parse(response.body)
      end
    end

    def self.availabilities(slug, query_params = {})
      validate_presence_of([:lat, :lon], query_params)
      params = { query: query_params }
      response = strains_availabilities_index({ slug: slug}, params)
      handle_parser_error do
        JSON.parse(response.body)
      end
    end

    private
    def self.handle_parser_error
      begin
        yield
      rescue JSON::ParserError
        puts "Seems that server did not return a valid JSON"
        {}
      end
    end

    def self.validate_presence_of(keys, hash)
      keys.each do |key|
        unless hash.keys.include?(key)
          raise ArgumentError, "Missing param '#{key}'"
        end
      end
    end
  end
end