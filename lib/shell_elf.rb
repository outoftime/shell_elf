gem 'escape'
require 'net/http'
require 'escape'
require 'logger'

module ShellElf
  autoload :Job, File.expand_path(File.join(File.dirname(__FILE__), 'shell_elf', 'job.rb'))
  autoload :Batch, File.expand_path(File.join(File.dirname(__FILE__), 'shell_elf', 'batch.rb'))
  autoload :Runner, File.expand_path(File.join(File.dirname(__FILE__), 'shell_elf', 'runner.rb'))
  
  class <<self
    attr_writer :logger

    def logger
      @logger ||= Logger.new(nil) # stub logger
    end
  end
end
