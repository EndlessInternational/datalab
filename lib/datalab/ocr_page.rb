module Datalab
  class OcrPage
    def initialize( attributes )
      @attributes = attributes&.dup || {}
    end
  
    def text_lines 
      ( @attributes[ :text_lines ] || [] ).map( &OcrTextLine.method( :new ) ) 
    end

    def languages 
      @attributes[ :languages ]
    end

    def number
      @attributes[ :page ]
    end

    def bounding_rectangle 
      @attributes[ :image_bbox ]
    end 
  end
end
