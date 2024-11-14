require 'json'
require 'base64'
require 'uri'

require 'faraday'
require 'faraday/multipart'
require 'dynamic_schema'

require_relative 'datalab/error_result'
require_relative 'datalab/request'
require_relative 'datalab/response_methods'

require_relative 'datalab/marker_options'
require_relative 'datalab/marker_result'
require_relative 'datalab/marker_request'

require_relative 'datalab/ocr_text_line'
require_relative 'datalab/ocr_page'
require_relative 'datalab/ocr_options'
require_relative 'datalab/ocr_result'
require_relative 'datalab/ocr_request'

require_relative 'datalab/module_methods'

module Datalab
  extend ModuleMethods
end


