module Datalab 

  ##
  # The +Request+ class encapsulates a request to the Datalab API. This class serves as the 
  # implementation of the MarkerRequest, OcrRequest and other classes and should not be used
  # directly.
  #  
  class Request 

    BASE_URI = 'https://www.datalab.to/api/v1'
   
    ##
    # The +initialize+ method initializes the +Request+ instance. You can pass an +api_key+ and
    # and optionally a (Faraday) +connection+.
    #
    def initialize( connection: nil, api_key: nil )
      @connection = connection || Datalab.connection
      @api_key = api_key || Datalab.api_key
      raise ArgumentError, "An 'api_key' is required unless configured using 'Datalab.api_key'." \
        unless @api_key
    end

  protected

    def post( uri, body, &block )
      @connection.post( uri, body, 'X-Api-Key' => @api_key, &block )
    end 

    def get( uri, &block )
      @connection.get( uri ) do | request |
        request.headers[ 'X-Api-Key' ] = @api_key
        block.call( request ) if block 
      end
    end 

  end

end
