module Datalab 
  class MarkerResult 

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
    # The +markdown+ method returns the markdown content extracted from the given document. 
    #
    def markdown 
      @attributes[ :markdown ]
    end 

    ##
    #
    #
    def images 
      @attribute[ :images ]
    end

    def metadata 
      unless @metadata 
        metadata = @attributes[ :metadata ] || {}
        @metadata = metadata.transform_keys do | key |
          key.to_s.gsub( /([a-z])([A-Z])/, '\1_\2' ).downcase
        end
      end 
      @metadata 
    end

    def merge( attributes )
      self.class.new( ( @attributes || {} ).merge( attributes ) )
    end

  end
end
