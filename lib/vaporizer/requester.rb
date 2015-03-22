module Vaporizer
  module Requester
    include HTTParty

    base_uri 'http://data.leafly.com'

    def define_httparty_request_wrapper(name, method, path, extra_headers = {})
      splited_path = split_path(path)
      url_params_defined = path_params(splited_path)
      sub_paths = splited_path - url_params_defined

      define_singleton_method name do |url_params = {}, query_params = {}|
        headers = { 'app_id' => Vaporizer.config.app_id, 
                    'app_key' => Vaporizer.config.app_key,
                    'Accept' => 'application/json'
                  }.merge(extra_headers)

        opts = { headers: headers }.merge(query_params)
        url_params_values = []

        url_params_defined.each do |param|
          clean_param = param[1..-1]
          if !url_params.keys.map(&:to_s).include?(clean_param)
            raise ArgumentError, "path param #{clean_param} is missing"
          else
            url_params_values << url_params[clean_param.to_sym]
          end
        end
        
        generated_path = sub_paths.zip(url_params_values).flatten.compact.join
        Vaporizer::Requester.send(method, generated_path, opts)
      end
    end

    private
    def split_path(path)
      path.split(/(:[a-z_]+)/)
    end

    def path_params(splited_path)
      splited_path.select { |e| e[0] == ':' }
    end
  end
end
