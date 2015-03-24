module Vaporizer
  class Error < StandardError; end
  class NotFound < Error; end
  class MissingParameter < Error; end
end
