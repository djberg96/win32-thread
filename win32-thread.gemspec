require 'rubygems'

spec = Gem::Specification.new do |gem|
   gem.name      = 'win32-thread'
   gem.version   = '0.0.3'
   gem.author    = 'Daniel J. Berger'
   gem.license   = 'Artistic 2.0'
   gem.email     = 'djberg96@gmail.com'
   gem.homepage  = 'http://www.rubyforge.org/projects/win32utils'
   gem.platform  = Gem::Platform::RUBY
   gem.summary   = 'An experimental library for native Windows threads'
   gem.test_file = 'test/test_win32_thread.rb'
   gem.has_rdoc  = true
   gem.files     = Dir['**/*'].reject{ |f| f.include?('CVS') }

   gem.rubyforge_project = 'win32utils'
   gem.extra_rdoc_files  = ['README', 'CHANGES', 'MANIFEST']

   gem.add_dependency('windows-pr', '>= 0.8.4')

   gem.description = <<-EOF
      The win32-thread library is and experimental library for native threads
      on MS Windows. Note that this library is largely a proof of concept
      library and should not be used in production systems because it is
      likely to crash the Ruby interpreter. Users of Ruby 1.9.x should not
      need this library since those versions use native threads by default.
   EOF
end

Gem::Builder.new(spec).build
