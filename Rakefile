require 'rake'
require 'rake/testtask'
require 'rbconfig'
include Config

desc 'Install the pure Ruby win32-thread library (non-gem)'
task :install do
   dest = File.join(Config::CONFIG['sitelibdir'], 'win32')
   Dir.mkdir(dest) unless File.exists? dest
   cp 'lib/win32/thread.rb', dest, :verbose => true
end

desc 'Run the sample program'
task :example do |t|
   ruby '-Ilib examples/example_thread.rb'
end

Rake::TestTask.new do |test|
   test.warning = true
   test.verbose = true
end
