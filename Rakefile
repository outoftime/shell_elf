require 'rubygems'

ENV['RUBYOPT'] = '-W1'

Dir['tasks/**/*.rake'].each { |t| load t }

task :default => :spec
