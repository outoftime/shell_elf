require 'rubygems'
gem 'sinatra'
require 'fileutils'
require 'tmpdir'
require 'sinatra'

post '/touch/:filename' do
  FileUtils.touch(File.join(Dir.tmpdir, 'shell_elf', 'sandbox', params[:filename]))
end
