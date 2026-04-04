require_relative 'lib/minitest/default_http_header/version'

Gem::Specification.new do |spec|
  spec.name          = 'minitest-default_http_header'
  spec.version       = Minitest::DefaultHttpHeader::VERSION
  spec.authors       = ['Keita Urashima']
  spec.email         = ['ursm@ursm.jp']
  spec.summary       = 'Set default HTTP headers in integration tests'
  spec.homepage      = 'https://github.com/ursm/minitest-default_http_header'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.3'

  spec.files         = Dir['lib/**/*.rb', 'LICENSE.txt', 'README.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'actionpack', '>= 7.1'
  spec.add_dependency 'activesupport', '>= 7.1'
end
