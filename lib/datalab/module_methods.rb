module Datalab
  module ModuleMethods
    DEFAULT_CONNECTION = Faraday.new do | builder | 
      builder.request :multipart
      builder.request :url_encoded
      builder.adapter Faraday.default_adapter 
    end
    
    def connection( connection = nil )
      @connection = connection || @connection || DEFAULT_CONNECTION    
    end

    def api_key( api_key = nil )
      @api_key = api_key || @api_key
      @api_key 
    end  
  end
end
