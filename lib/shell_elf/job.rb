module ShellElf
  class Job
    class <<self
      def execute(command)
        new(command).execute
      end
    end

    def initialize(command)
      @command = command
    end

    def execute
      escaped_command = Escape.shell_command(@command)
      ShellElf.logger.info(escaped_command)
      fork do
        # this way we can detach from the shell session
        # so the child process doesn't receive SIGINTs
        Process.setsid
        exec(escaped_command)
      end
      Process.wait(-1)
      @success = $? == 0
      ShellElf.logger.debug(@success ? 'success' : 'failed')
      self
    end

    def success?
      @success
    end
  end
end
