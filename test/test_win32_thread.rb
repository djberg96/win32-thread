########################################################################
# test_win32_thread.rb
#
# Test suite for the win32-thread library. These tests should be run
# via the rake test task.
#
# There is a good chance this test suite will cause the Ruby
# interpreter to crash, so don't be alarmed.
########################################################################
require 'win32/thread'
require 'test/unit'

class TC_Win32_Thread < Test::Unit::TestCase
   def setup
      @t = Win32::Thread.new{ }
   end
   
   def test_version
      assert_equal('0.0.3', Win32::Thread::VERSION)
   end
   
   def test_terminate
      assert_respond_to(@t, :terminate)
      assert_nothing_raised{ @t.terminate }
   end
   
   def test_exit
      assert_respond_to(@t, :exit)
      assert_nothing_raised{ @t.exit }
   end
   
   def test_join
      assert_respond_to(@t, :join)
      assert_nothing_raised{ @t.join }
   end
   
   def teardown
      @t.join
   end
end
