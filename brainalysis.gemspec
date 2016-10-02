Gem::Specification.new do |gem|
  gem.name        = 'Brainalysis'
  gem.version     = '0.0.0'
  gem.date        = '2016-09-26'
  gem.summary     = "Brainalysis"
  gem.description = "Brainalysis is a Ruby library for analysis of eeg data."
  gem.authors     = ['Prasun Anand']
  gem.email       = 'prasunanand.bitsp@gmail.com'
  gem.files       = ["lib/brainalysis.rb"]
  gem.homepage    = 'http://rubygems.org/gems/brainalysis'
  gem.license     = 'MIT'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'bundler', '~>1.6'
  gem.add_development_dependency 'json'
  gem.add_development_dependency 'pry', '~>0.10'
  gem.add_development_dependency 'rake', '~>10.3'
  gem.add_development_dependency 'rake-compiler', '~>0.8'
  gem.add_development_dependency 'rdoc', '~>4.0', '>=4.0.1'
  gem.add_development_dependency 'rspec', '~>2.14'
end