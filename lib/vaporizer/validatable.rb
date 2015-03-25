require 'vaporizer/error'

module Vaporizer
  module Validatable
    def validate_presence_of(keys, hash)
      keys.each do |key|
        unless hash.keys.include?(key)
          raise Vaporizer::MissingParameter, "Missing param '#{key}'"
        end
      end
    end
  end
end
