require 'rubygems'
gem 'sinatra'
require 'fileutils'
require 'sinatra'

post '/touch/:filename' do
  FileUtils.touch(File.join(File.dirname(File.dirname(__FILE__)), 'sandbox', params[:filename]))
end
