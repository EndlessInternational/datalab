module Datalab
  class OcrTextLine
    def initialize( attributes )
      @attributes = attributes&.dup || {}
    end
  
    def text 
      @attributes[ :text ]
    end

    def confidence
      @attributes[ :confidence ]
    end

    def bounding_polygon
      @attributes[ :polygon ]
    end

    def bounding_rectangle 
      @attributes[ :image_bbox ]
    end 
  end
end
