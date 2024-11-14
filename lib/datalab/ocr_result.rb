module Datalab 
  class OcrResult 

    def initialize( attributes )
      @success = 
        attributes[ :success ] || 
        [ :processing, :complete ].include?( attributes[ :status ]&.to_sym )
      @attributes = attributes || {}
    end

    def id 
      @attributes[ :request_id ]
    end

    ##
    # The +success?+ method returns +true+ if the converstion was successful. 
    #
    # Note that the response +success?+ tells you if the call to the Datalab API was successful 
    # while this +success?+ method tells you if the actual conversaion operation began 
    # successfully.
    #
    def success?  
      @success || false 
    end

    def status 
      @attributes[ :status ]&.to_sym || :processing 
    end 

    def processing?
      status == :processing 
    end 

    def complete?
      status == :complete
    end 

    ##
    # If +success?+ returns +false+ this method will return a message explaining the reason 
    # for the failure.
    # 
    def failure_message
      @attributes[ :error ]
    end 

    ##
    # The +pages+ method returns the pages extracted from the given document. If the given 
    # document was an image the result is an array with a single page. If no pages were recognized
    # the result is an empty array.
    #
    def pages
      ( @attributes[ :pages ] || [] ).map( &OcrPage.method( :new ) ) 
    end 

    def page_count
      @attributes[ :page_count ]
    end

    def merge( attributes )
      self.class.new( ( @attributes || {} ).merge( attributes ) )
    end

  end
end
