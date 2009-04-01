begin
  gem 'technicalpickles-jeweler', '~> 0.8.1'
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = 'shell_elf'
    s.executables = 'shell-elf'
    s.summary = 'Daemon which executes shell commands read out of a Starling queue and optionally posts back to an HTTP server on success/failure'
    s.email = 'mat@patch.com'
    s.homepage = 'http://github.com/outoftime/sunspot'
    s.description = 'Daemon which executes shell commands read out of a Starling queue and optionally posts back to an HTTP server on success/failure'
    s.authors = ['Mat Brown']
    s.files = FileList['[A-Z]*', '{bin,lib,spec,tasks,script}/**/*']
    s.has_rdoc = false
    s.add_dependency 'escape', '>= 0.0.4'
    s.add_dependency 'starling-starling', '~> 0.9'
    s.add_dependency 'daemons', '~> 1.0'
    s.add_dependency 'choice', '>= 0.1'
    s.add_development_dependency 'rspec', '~> 1.1'
    s.add_development_dependency 'ruby-debug', '~> 0.10'
    s.add_development_dependency 'sinatra', '>= 0.9'
  end
end
