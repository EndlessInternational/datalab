require_relative '../lib/datalab.rb'

request = Datalab::MarkerRequest.new( api_key: ENV[ 'DATALAB_API_KEY' ] )

file = Faraday::UploadIO.new( ARGV[ 0 ], 'application/pdf' )
response = request.submit( file, { maximum_pages: 5, extract_images: false, paginate: true } )

while response.success? && ( result = response.result ).success?
  break if result.complete?
  response = request.retrieve( result )
end

if response.success? 
  if response.result.success?
    puts response.result.markdown 
  else 
    puts response.result.failure_message
  end
else
  puts response.result.error_description 
end 


