require 'vaporizer/strain'
require 'vaporizer/http_client'
require 'vaporizer/version'
require 'vaporizer/error'

module Vaporizer

  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Config.new
    yield config
  end

  class Config
    attr_accessor :app_id, :app_key

    def initialize
      @app_id = ""
      @app_key = ""
    end
  end
end
