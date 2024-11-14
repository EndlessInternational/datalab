require_relative '../lib/datalab.rb'

request = Datalab::OcrRequest.new( api_key: ENV[ 'DATALAB_API_KEY' ] )

file = Faraday::UploadIO.new( ARGV[ 0 ], 'image/jpeg' )
response = request.submit( file )

while response.success? && ( result = response.result ).success?
  break if result.complete?
  response = request.retrieve( result )
end

if response.success? 
  if response.result.success?
    pages = response.result.pages 
    pages.each do | page |
      page.text_lines.each do | line |
        puts line.text
      end
    end
  else 
    puts response.result.failure_message
  end
else
  puts response.result.error_description 
end 


