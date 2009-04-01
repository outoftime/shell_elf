require 'fileutils'
require 'tmpdir'

namespace :spec do
  desc "Start spec environment processes"
  task :environment do
    base_dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
    spec_dir = File.join(base_dir, 'spec')
    tmp_dir = File.join(Dir.tmpdir, 'shell_elf')
    FileUtils.mkdir_p(File.join(tmp_dir, 'log'))
    trap('INT') { } # will be passed on to children, then we'll exit gracefully
    fork do
      exec("starling -P #{File.join(tmp_dir, 'log', 'starling.pid')} -p 73787")
    end
    fork do
      exec("ruby #{spec_dir}/services/http_service.rb -p 7397")
    end
    Process.waitall
  end
end
