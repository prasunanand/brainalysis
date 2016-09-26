Gem::Specification.new do |gem|
  gem.name        = 'Brainalysis'
  gem.version     = '0.0.0'
  gem.date        = '2016-09-26'
  gem.summary     = "Brainalysis"
  gem.description = "Brainalysis is a Ruby library for analysis of eeg data."
  gem.email       = 'prasunanand.bitsp@gmail.com'
  gem.files       = ["lib/brainalysis.rb"]
  gem.homepage    = 'http://rubygems.org/gems/brainalysis'
  gem.license     = 'MIT'
  gem.add_development_dependency "bundler", '~> 1.8', '>= 1.8.4'
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rubocop"
  gem.add_runtime_dependency "nmatrix"
end