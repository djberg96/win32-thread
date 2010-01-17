#######################################################################
# example_thread.rb
#
# This is a sample program demonstrating the win32-thread library.
# You can run it via the 'rake example' task.
#
# Modify as you see fit.
#######################################################################
require "win32/thread"
require "net/http"

class Foo
   attr_accessor :arg1
   def initialize(arg1 = "test")
      @arg1 = arg1
   end
end

f = Foo.new
t = Win32::Thread.new(f){ |myf|
   p myf
   sleep 2
}

puts "Done"
t.join


=begin
# This example fails utterly and will cause an application error
# It appears that block arguments aren't being handled properly
threads = []
a = Foo.new
b = Foo.new

[a,b].each{ |foo|
   threads << Win32::Thread.new(foo){ |myf|
      p myf
      puts "hello"
      sleep 2
   }
}

puts "Done"
sleep 1
threads.each{ |t| t.join }
=end

=begin
# This example dies with "cross-thread violation on rb_thread_schedule()"
# which appears to be a hard coded error in eval.c if you attempt to use a
# native thread.
threads = []
pages = %w/
   www.rubycentral.com
   www.awl.com
   www.pragmaticprogrammer.com
/
			  
for page in pages
   threads << Win32::Thread.new(page){ |mypage|
      h = Net::HTTP.new(mypage,80)
      puts "Fetching: #{mypage}"
      resp,data = h.get('/',nil)
      puts "Got #{mypage}: #{resp.message}"
   }
end
	
threads.each{ |thread| thread.join }
=end