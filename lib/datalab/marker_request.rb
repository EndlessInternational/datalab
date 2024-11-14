module Datalab 

  ##
  # The +MarkerRequest+ class encapsulates a document conversion request in the Datalab API. 
  # After instantiating a new +MarkerRequest+ instance you can begin a markdown conversion 
  # document by calling the +submit+ method and then subsequently retrieving the results by 
  # calling the +retrieve+' method.
  #
  # === examples
  # 
  # require 'datalab'
  #
  # request = Datalab::MarkerRequest.new( api_key: ENV[ 'DATALAB_API_KEY' ] )
  # 
  # file = Faraday::UploadIO.new( ARGV[ 0 ], 'application/pdf' )
  # response = request.submit( file )
  # while response.success? && ( result = response.result ).success?
  #   result = request.retrieve( result )
  #   break if result.complete?
  # end
  #
  # if response.success? 
  #   if response.result.success?
  #     puts response.result.markdown 
  #   else 
  #     puts response.result.failure_message
  #   end
  # else
  #   puts response.result.error_description 
  # end 
  # 
  class MarkerRequest < Request 

    ## 
    # The +submit+ method makes a Datalab '/marker' POST request which will begin conversion of 
    # the given file to markdown.  
    # 
    # The response is always an instance of +Faraday::Response+. If +response.success?+ is true,
    # then +response.result+ will be an instance +MarkerResult+. If the request is not successful 
    # then +response.result+ will be an instance of +ErrorResult+.
    #
    # Remember that you should call +response.success?+ to validate that the call to the API was
    # successful and then +response.result.success?+ to validate that the API processed the
    # request successfuly. 
    #
    def submit( file, options = nil, &block )        
      if options
        options = options.is_a?( MarkerOptions ) ? options : MarkerOptions.build( options.to_h ) 
        options = options.to_h
      else 
        options = {}
      end
      options[ :file ] = file 
      response = post( "#{BASE_URI}/marker", options, &block )
      result = nil 
      if response.success?
        attributes = ( JSON.parse( response.body, symbolize_names: true ) rescue nil )
        attributes ||= { success: false, status: :failed, error: 'An unknown error occured.'  }
        result = MarkerResult.new( attributes )
      else
        attributes = JSON.parse( response.body, symbolize_names: true ) rescue {}
        result = ErrorResult.new( response.status, attributes )
      end

      ResponseMethods.install( response, result )  
    end 

    ## 
    # The +retrieve+ method takes the successful result of the submit method and makes a Datalab 
    # '/marker/{id}' GET request which will return the conversion progress result or, if 
    # conversion has been completed, the conversion results. 
    #  
    # The response is always an instance of +Faraday::Response+. If +response.success?+ is +true+, 
    # then +response.result+ will be an instance +Datalab::MarkerResult+. If the request is not 
    # successful then +response.result+ will be an instance of +Datalab::ErrorResult+.
    #
    # Remember that you should call +response.success?+ to valida that the call to the API was
    # successful and then +response.result.success?+ to validate that the API processed the
    # request successfuly. 
    #
    def retrieve( submit_result, &block )
      raise ArgumentError, "The first argument must be an instance of MarkerResult." \
        unless submit_result.is_a?( MarkerResult )

      response = get( "#{BASE_URI}/marker/#{submit_result.id}", &block )  
      result = nil 
      attributes = JSON.parse( response.body, symbolize_names: true ) rescue nil 

      if response.success? 
        result = submit_result.merge( attributes || { success: false, status: :failed } )
      else
        result = ErrorResult.new( response.status, attributes || {} )
      end 

      ResponseMethods.install( response, result )     
    end

  end 
end
