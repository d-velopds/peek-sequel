# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'peek-sequel/version'

Gem::Specification.new do |gem|
  gem.name = 'peek-sequel'
  gem.version = Peek::Sequel::VERSION
  gem.authors = ['Jonas Oberschweiber']
  gem.email =  ['jonas.oberschweiber@d-velop.de']
  gem.description = %q{Take a peek into the Sequel SQL queries made in your application}
  gem.summary = gem.description
  gem.homepage = 'https://github.com/d-velopds/peek-sequel'
  gem.license = 'MIT'

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'peek'
  gem.add_dependency 'sequel', '~> 5.96', '>= 5.96.0'
  gem.add_dependency 'concurrent-ruby', '~> 1.3', '>= 1.3.0'
end
