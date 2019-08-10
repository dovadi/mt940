$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'mt940/version'

Gem::Specification.new do |s|
  s.name        = 'mt940'
  s.version     = MT940::VERSION
  s.authors     = ['Frank Oxener']
  s.description = 'A basic MT940 parser with implementations for Dutch banks.'
  s.summary     = 'MT940 parser'
  s.email       = 'frank.oxener@gmail.com'

  s.homepage    = 'https://github.com/dovadi/mt940'
  s.licenses    = ['MIT']

  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.md'
  ]

  s.rubyforge_project = 'mt940'

  s.files         = `git ls-files`.split(/\n/)
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split(/\n/)
  s.executables   = `git ls-files -- bin/*`.split(/\n/).map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
