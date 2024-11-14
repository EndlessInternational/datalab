Gem::Specification.new do | spec |

  spec.name             = 'datalab'
  spec.version          = '0.1.0'
  spec.authors          = [ 'Kristoph Cichocki-Romanov' ]
  spec.email            = [ 'rubygems.org@kristoph.net' ]

  spec.summary          = 
    "The Datalab gem implements a lightweight interface to the Datalab API which provides " \
    "document to Markdown conversion as well as sophisticated OCR for documents and images."
  spec.description      =
    "The Datalab gem implements a lightweight interface to the Datalab API. The Datalab API " \
    "can convert a number of document formats, including PDF, Word and Powerpoint to Markdown. " \
    "In addition in offers sophisticate OCR, layout and line detection for documents an images." 
  spec.license          = 'MIT'
  spec.homepage         = 'https://github.com/EndlessInternational/datalab'
  spec.metadata         = {
    'source_code_uri'   => 'https://github.com/EndlessInternational/datalab',
    'bug_tracker_uri'   => 'https://github.com/EndlessInternational/datalab/issues',
#    'documentation_uri' => 'https://github.com/EndlessInternational/datalab'
  }

  spec.required_ruby_version = '>= 3.0'
  spec.files            = Dir[ "lib/**/*.rb", "LICENSE", "README.md", "datalab.gemspec" ]
  spec.require_paths    = [ "lib" ]

  spec.add_runtime_dependency 'faraday', '~> 2.7'
  spec.add_runtime_dependency 'faraday-multipart', '~>1.0'
  spec.add_runtime_dependency 'dynamicschema', '~> 1.0.0.beta04'

  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'debug', '~> 1.9'
  spec.add_development_dependency 'vcr', '~> 6.3'

end
