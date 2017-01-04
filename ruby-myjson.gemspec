# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'myjson/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-myjson'
  spec.version       = Myjson::VERSION
  spec.authors       = ['Nikita Chernov']
  spec.email         = ['nikita.cernovs@accenture.com']

  spec.summary       = 'Myjson Ruby Client'
  spec.description   = 'Ruby client for Myjson http://myjson.com'
  spec.homepage      = 'https://github.com/nikitachernov/ruby-myjson'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '0.46.0'
  spec.add_development_dependency 'vcr', '3.0.3'
end
