lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gifs/version'

Gem::Specification.new do |spec|
  spec.name          = 'gifs'
  spec.version       = Gifs::VERSION
  spec.authors       = ['Josh Mills']
  spec.email         = ['josh@trueheart78.com']

  spec.summary       = 'A dropbox-based gif manager for my ever-growing collection.'
  spec.homepage      = 'https://github.com/trueheart78/gifs'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib db]

  spec.add_runtime_dependency 'activerecord', '~> 5.1.4'
  spec.add_runtime_dependency 'activesupport', '~> 5.1.4'
  spec.add_runtime_dependency 'sqlite3', '~> 1.3.13'
  spec.add_runtime_dependency 'faraday', '~> 0.13.1'
  spec.add_runtime_dependency 'typhoeus', '~> 1.3.0'
  spec.add_runtime_dependency 'colorize', '~> 0.8'
  spec.add_runtime_dependency 'clipboard', '~> 1.1'
  spec.add_development_dependency 'bundler', '~> 1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-junklet', '~> 2.2'
  spec.add_development_dependency 'factory_bot', '~> 4.8'
  spec.add_development_dependency 'webmock', '~> 3.0.1'
  spec.add_development_dependency 'simplecov', '~> 0.15.1'
  spec.add_development_dependency 'simplecov-rcov', '~> 0.2.3'
  spec.add_development_dependency 'rubocop', '~> 0.50'
  spec.add_development_dependency 'byebug', '~> 9.1'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.3.0' # circleci requirement
end
