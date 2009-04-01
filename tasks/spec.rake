require 'fileutils'
require 'tmpdir'

namespace :spec do
  desc "Start spec environment processes"
  task :environment do
    base_dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
    spec_dir = File.join(base_dir, 'spec')
    tmp_dir = File.join(Dir.tmpdir, 'shell_elf')
    FileUtils.mkdir_p(File.join(tmp_dir, 'log'))
    FileUtils.mkdir_p(File.join(tmp_dir, 'sandbox'))
    running = true
    trap('INT') { running = false }
    trap('TERM') { running = false }
    fork do
      exec("starling -P #{File.join(tmp_dir, 'log', 'starling.pid')} -p 73787")
    end
    fork do
      exec("ruby #{spec_dir}/services/http_service.rb -p 7397")
    end
    while running
      shell_elf_pid = fork do
        exec("#{File.join(base_dir, 'bin', 'shell-elf')} run -- -p 73787 -q shell_elf_test --log-file=#{File.join(tmp_dir, 'log', 'shell_elf.out')} --log-level=DEBUG")
      end
      File.open(File.join(tmp_dir, 'log', 'shell-elf.pid'), 'w') { |f| f << shell_elf_pid }
      Process.waitpid(shell_elf_pid)
    end
    Process.waitall
  end
end
