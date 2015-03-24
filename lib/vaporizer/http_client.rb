require 'httparty'

module Vaporizer
  module HttpClient
    include HTTParty

    default_timeout 1
    base_uri 'http://data.leafly.com'

    def define_httparty_request_wrapper(name, method, route, extra_headers = {})
      splited_route = split_route(route)
      route_params_defined = extract_params_from_route(splited_route)
      sub_paths = splited_route - route_params_defined

      route_params_defined = strip_symbolize_route_params(route_params_defined)

      define_singleton_method name do |params_given = {}, query_params = {}|
        headers = { 'app_id' => Vaporizer.config.app_id,
                    'app_key' => Vaporizer.config.app_key,
                    'Accept' => 'application/json'
                  }.merge(extra_headers)

        opts = { headers: headers }.merge(query_params)

        params_values = get_route_params_values(route_params_defined, params_given)
        built_path = build_path(sub_paths, params_values)

        response = Vaporizer::HttpClient.send(method, built_path, opts)
        if response.code == 404
          raise Vaporizer::NotFound, 'The requested resource was not found'
        else
          return response.parsed_response
        end
      end
    end

    def get_route_params_values(url_params, params_given)
      params_values = []
      url_params.each do |param|
        if !params_given.keys.include?(param)
          raise Vaporizer::MissingPathParameter, "Path parameter #{param} is missing"
        else
          params_values << params_given[param]
        end
      end
      params_values
    end

    private
    def build_path(sub_paths, params_values)
      sub_paths.zip(params_values).flatten.compact.join
    end

    def strip_symbolize_route_params(params_array)
      params_array.map { |param| param[1..-1].to_sym }
    end

    def split_route(route)
      route.split(/(:[a-z_]+)/)
    end

    def extract_params_from_route(splited_path)
      splited_path.select { |e| e[0] == ':' }
    end
  end
end
