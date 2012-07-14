# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "notches/version"

Gem::Specification.new do |s|
  s.name        = 'notches'
  s.version     = Notches::VERSION
  s.authors     = ["Cillian O'Ruanaidh", "Paul Campbell"]
  s.email       = ['contact@cilliano.com']
  s.homepage    = 'http://github.com/hypertiny/notches'
  s.summary     = %q{Simple Rails web traffic counter}
  s.description = %q{A Rails Engine for tracking your web traffic.}

  s.rubyforge_project = 'notches'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f|
    File.basename(f)
  }
  s.require_paths = ['lib']

  s.add_runtime_dependency     'rails',           '~> 3.1'

  s.add_development_dependency 'combustion', '~> 0.3.2'
  s.add_development_dependency 'rspec-rails', '~> 2.11'
  s.add_development_dependency 'sqlite3',     '~> 1.3.4'
end
