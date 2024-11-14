module Datalab
  class OcrOptions
    include DynamicSchema::Definable 

    schema do 
      maximum_pages       Integer, as: :max_pages, in: (1..)
      languages           String, array: true
    end

    def self.build( options = nil, &block )
      new( api_options: builder.build( options, &block ) )
    end 

    def self.build!( options = nil, &block )
      new( api_options: builder.build!( options, &block ) )
    end 

    def initialize( options = {}, api_options: nil )
      @options = self.class.builder.build( options || {} )
      @options = api_options.merge( @options ) if api_options 
    end

    def to_h
      @options.to_h 
    end

  end
end


