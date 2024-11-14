module Datalab 

  ##
  # The +OcrRequest+ class encapsulates a document or image recognition request in the Datalab API. 
  # After instantiating a new +OcrRequest+ instance you can begin recognition by calling the 
  # +submit+ method and then subsequently retrieving the results by calling the +retrieve+ method.
  #
  # === examples
  # 
  # require 'datalab'
  #
  # request = Datalab::OcrRequest.new( api_key: ENV[ 'DATALAB_API_KEY' ] )
  # 
  # file = Faraday::UploadIO.new( ARGV[ 0 ], 'image/jpeg' )
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
  class OcrRequest < Request 

    ## 
    # The +submit+ method makes a Datalab '/ocr' POST request which will begin recognition of the 
    # given file.  
    # 
    # The response is always an instance of +Faraday::Response+. If +response.success?+ is true,
    # then +response.result+ will be an instance +OcrResult+. If the request is not successful 
    # then +response.result+ will be an instance of +ErrorResult+.
    #
    # Remember that you should call +response.success?+ to validate that the call to the API was
    # successful and then +response.result.success?+ to validate that the API processed the
    # request successfuly. 
    #
    def submit( file, options = nil, &block )        
      if options
        options = options.is_a?( OcrOptions ) ? options : OcrOptions.build( options.to_h ) 
        options = options.to_h
      else 
        options = {}
      end
      options[ :file ] = file 
      response = post( "#{BASE_URI}/ocr", options, &block )
      result = nil 
      if response.success?
        attributes = ( JSON.parse( response.body, symbolize_names: true ) rescue nil )
        attributes ||= { success: false, status: :failed, error: 'An unknown error occured.'  }
        result = OcrResult.new( attributes )
      else
        attributes = JSON.parse( response.body, symbolize_names: true ) rescue {}
        result = ErrorResult.new( response.status, attributes )
      end

      ResponseMethods.install( response, result )  
    end 

    ## 
    # The +retrieve+ method takes the successful result of the submit method and makes a Datalab 
    # '/ocr/{id}' GET request which will return the recognition progress result or, if recognition 
    # has been completed, the recognition results. 
    #  
    # The response is always an instance of +Faraday::Response+. If +response.success?+ is +true+, 
    # then +response.result+ will be an instance +Datalab::OcrResult+. If the request is not 
    # successful then +response.result+ will be an instance of +Datalab::ErrorResult+.
    #
    # Remember that you should call +response.success?+ to valide that the call to the API was
    # successful and then +response.result.success?+ to validate that the API processed the
    # request successfuly. 
    #
    def retrieve( submit_result, &block )
      raise ArgumentError, "The first argument must be an instance of OcrResult." \
        unless submit_result.is_a?( OcrResult )

      response = get( "#{BASE_URI}/ocr/#{submit_result.id}", &block )  
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
