module Vaporizer
  class Error < StandardError; end

  class ServerError < Error; end
  class NotFound < ServerError; end

  class ClientError < Error; end
  class MissingPathParameter < Error; end
  class MissingParameter < Error; end
end
