require 'rubygems'
gem 'rspec'
gem 'starling-starling'
require 'fileutils'
require 'tmpdir'
require 'spec'
require 'starling'
require 'ruby-debug'

Spec::Runner.configure do |config|
  config.before(:all) do
    @starling = Starling.new('localhost:73787')
    begin
      @starling.stats
    rescue
      abort('Starling is not responding! Run rake spec:environment to start background services.')
    end
  end

  config.before(:each) do
    root = File.expand_path(File.dirname(File.dirname(__FILE__)))
    tmp_dir = File.join(Dir.tmpdir, 'shell_elf')
    FileUtils.mkdir_p(File.join(tmp_dir, 'log'))
    FileUtils.mkdir_p(File.join(tmp_dir, 'sandbox'))
    @shell_elf_pid = fork do
      exec("#{File.join(root, 'bin', 'shell-elf')} run -- -p 73787 -q shell_elf_test --log-file=#{File.join(tmp_dir, 'log', 'shell_elf.out')} --log-level=DEBUG")
    end
    Process.detach(@shell_elf_pid)
    @starling.delete('shell_elf_test')
    for entry in Dir.glob(File.join(tmp_dir, 'sandbox', '*'))
      if File.file?(entry)
        FileUtils.rm_r(File.expand_path(entry))
      end
    end
  end

  config.after(:each) do
    if @shell_elf_pid
      Process.kill('TERM', @shell_elf_pid)
      pid_wait(@shell_elf_pid)
    end
  end
end

module SpecHelper
  def sandbox(*path)
    File.expand_path(File.join(Dir.tmpdir, 'shell_elf', 'sandbox', path))
  end

  def starling_send_and_wait(params)
    starling_send(params)
    starling_wait
  end

  def starling_send(params)
    @starling.set('shell_elf_test', params)
  end

  def starling_wait
    starling_send(:command => ['true'])
    100.times do |i|
      return if @starling.sizeof('shell_elf_test') == 0
      sleep 0.01
    end
    raise 'Timed out waiting for Starling queue to clear.'
  end

  def http_touch_url(filename)
    "http://localhost:7397/touch/#{filename}"
  end

  def pid_wait(pid, timeout = 1)
    (timeout * 100).times do
      begin
        Process.kill(0, pid)
        sleep 0.01
      rescue Errno::ESRCH
        return
      end
    end
    raise "Timed out waiting for pid #{pid} to end!"
  end
end
