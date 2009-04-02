module ShellElf
  class Runner
    class <<self
      private :new

      def run(options)
        runner = new(options)
        signal_handler = proc do
          ShellElf.logger.info("Received signal - gracefully exiting...")
          exit if runner.interrupted!
        end
        trap('INT', &signal_handler)
        trap('TERM', &signal_handler)
        runner.run
      end
    end

    def initialize(options)
      @options = options
    end

    def run
      until @interrupted
        if starling && @current = starling.fetch(@options[:queue])
          ShellElf.logger.debug("RUNNER: #{@current.inspect}")
          ShellElf::Batch.execute(@current)
        else
          sleep Starling::WAIT_TIME
        end
      end
    end

    def interrupted!
      # return true unless @current
      if @current && @current[:options] && @current[:options][:on_interrupt] == :requeue
        starling.set(@options[:queue], @current)
        true
      else
        @interrupted = true
        false
      end
    end

    private

    def starling(delay = nil)
      begin
        sleep(delay) if delay
        @queue ||= Starling.new("#{@options[:host]}:#{@options[:port]}")
        @queue.stats
        @queue
      rescue MemCache::MemCacheError => e
        ShellElf.logger.error("Unable to connect to Starling: #{e.message}")
        @queue = nil
        delay ||= 0.125
        delay = delay *= 2 if delay < 1
        retry unless @interrupted
      end
    end
  end
end
