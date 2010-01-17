require 'windows/thread'
require 'windows/synchronize'
require 'windows/error'
include Windows

# The Win32 module serves as a namespace only. It is mandatory for use with
# this class to distinguish between a Windows thread and a standard core
# Ruby thread.
#
module Win32
   # The Thread class encapsulates a native MS Windows thread.
   class Thread
      include Windows::Thread
      include Windows::Synchronize
      include Windows::Error
      extend Windows::Synchronize
      
      # Error typically raised if any of the thread related methods fail.
      class Error < StandardError; end
      
      @@mutex = CreateMutex(nil, false, nil)
 
      # Above normal thread priority.
      ABOVE_NORMAL = THREAD_PRIORITY_ABOVE_NORMAL

      # Below normal thread priority.
      BELOW_NORMAL = THREAD_PRIORITY_BELOW_NORMAL

      # Highest thread priority.
      HIGHEST = THREAD_PRIORITY_HIGHEST

      # Idle thread priority.
      IDLE = THREAD_PRIORITY_IDLE

      # Lowest thread priority.
      LOWEST = THREAD_PRIORITY_LOWEST

      # Normal thread priority. This is the default.
      NORMAL = THREAD_PRIORITY_NORMAL

      # Critical thread priority.
      CRITICAL = THREAD_PRIORITY_TIME_CRITICAL
 
      # The version of the win32-thread library
      VERSION = '0.0.3'
      
      # :stopdoc:
      
      WinThreadFunc = API::Callback.new('L', 'L'){ |args_ptr|
         args = ObjectSpace._id2ref(args_ptr)
         block = args.pop
         block.call(args)
         ReleaseMutex(@@mutex)
      }
      
      # :startdoc:
      
      # The ID of the thread object.
      attr_reader :thread_id
      
      # Creates and returns a native Windows thread to execute the instructions
      # in the block. Any arguments passed to Win32::Thread.new are passed to
      # the block as per a standard Ruby thread.
      #
      def initialize(*args, &block)
         raise ArgumentError, 'block must be provided' unless block_given?
         args.push(block)

         thread_id = [0].pack('L')
         dwArgs    = args.object_id
         
         @thread = CreateThread(
            nil,           # Handle cannot be inherited
            0,             # Default stack size
            WinThreadFunc, # Pointer to thread func
            dwArgs,        # Arguments passed to thread func         
            0,             # Execute immediately, i.e. not suspended
            thread_id      # Stores the thread id
         )
         
         if @thread == 0
            raise Error, get_last_error
         end
         
         @thread_id = thread_id.unpack('L')[0]
      end
      
      # The calling thread will suspend execution and run the thread. Does not
      # return until the thread exits or until +limit+ seconds have passed. If
      # the time limit expires, nil will be returned. Otherwise, the thread
      # is returned.
      #--
      # WARNING: Joining multiple threads will cause the interpreter to
      # segfault here.
      #
      def join(limit = INFINITE)
         limit = limit * 1000 unless limit == INFINITE
         WaitForSingleObject(@thread, limit)
         ReleaseMutex(@@mutex)         
      end
      
      # Terminate the thread.
      #
      # WARNING: This is a dangerous method that should only be used in the
      # most extreme cases. You should call this method only if you know
      # exactly what the target thread is doing, and you control all of the
      # code that the target thread could possibly be running at the time
      # of the termination.
      #
      def terminate
         exit_code = [0].pack('L')
         return nil unless TerminateThread(@thread, exit_code)        
      end
      
      # Terminates the thread and schedules another thread to be run. If this
      # thread is already marked to be killed, exit returns the Thread. If this
      # is the main thread, or the last thread, exits the process.
      #
      def exit
         ExitThread(0)
      end
      
      # Returns the thread priority. This is a numeric value.
      #
      def priority
         GetThreadPriority(@thread)
      end
      
      # Sets the thread's priority. This is a numeric value. See the priority
      # constants for a list of valid values.
      #
      def priority=(value)
         unless SetThreadPriority(@thread, value)
            raise Error, get_last_error
         end
      end
   end
end
