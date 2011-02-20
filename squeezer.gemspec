# -*- encoding: utf-8 -*-
require File.expand_path('../lib/squeezer/version', __FILE__)

Gem::Specification.new do |s|
  s.add_development_dependency('bundler', '~> 1.0')
  s.add_development_dependency('rake', '~> 0.8')
  s.add_development_dependency('rspec', '~> 2.3')
  s.add_development_dependency('mocha', '~> 0.9.10')
  s.add_development_dependency('simplecov', '~> 0.3')
  s.add_development_dependency('maruku', '~> 0.6')
  s.add_development_dependency('yard', '~> 0.6')
  s.add_development_dependency('spork', '~> 0.8.4')
  s.add_development_dependency('autotest-standalone', '~> 4.5.5')
  
  s.authors = ["Daniël van Hoesel"]
  s.description = %q{A Ruby wrapper for the Squeezebox Server CLI API}
#  s.post_install_message 
  s.email = ['daniel@danielvanhoesel.nl']
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://squeezer.rubyforge.org/'
  s.name = 'squeezer-ruby'
  s.platform = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  s.rubyforge_project = s.name
  s.summary = %q{Ruby wrapper for the Squeezebox Server CLI API}
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Squeezer::VERSION.dup
end
