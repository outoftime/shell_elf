require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'ShellElf' do
  include SpecHelper

  shared_examples_for 'successful batch' do
    it 'should postback to success URL' do
      File.exist?(sandbox('success')).should be_true
    end

    it 'should not postback to failure URL' do
      File.exist?(sandbox('failure')).should be_false
    end
  end

  shared_examples_for 'failed batch' do
    it 'should postback to failure URL' do
      File.exist?(sandbox('failure')).should be_true
    end

    it 'should not postback to success URL' do
      File.exist?(sandbox('success')).should be_false
    end
  end

  it 'should run a single command' do
    starling_send_and_wait(:command => ['touch', sandbox('test')])
    File.exist?(sandbox('test')).should be_true
  end

  it 'should run multiple commands' do
    starling_send_and_wait(:commands => [['touch', sandbox('first')], ['touch', sandbox('second')]])
    %w(first second).all? { |f| File.exist?(sandbox(f)) }.should be_true
  end

  describe 'on success with single command' do
    before :each do
      starling_send_and_wait(:command => ['true'], :options => { :success => http_touch_url('success'), :failure => http_touch_url('failure') })
    end

    it_should_behave_like 'successful batch'
  end

  describe 'on failure with single command' do
    before :each do
      starling_send_and_wait(:command => ['false'], :options => { :success => http_touch_url('success'), :failure => http_touch_url('failure') })
    end

    it_should_behave_like 'failed batch'
  end

  describe 'with failed command followed by successful command' do
    before :each do
      starling_send_and_wait(:commands => [['false'], ['touch', sandbox('never_get_here')]], :options => { :success => http_touch_url('success'), :failure => http_touch_url('failure') })
    end

    it_should_behave_like 'failed batch'

    it 'should not run successful command' do
      File.exist?(sandbox('never_get_here')).should be_false
    end
  end

  describe 'with successful command followed by failed command' do
    before :each do
      starling_send_and_wait(:commands => [['touch', sandbox('first')], ['false']], :options => { :success => http_touch_url('success'), :failure => http_touch_url('failure') })
    end

    it_should_behave_like 'failed batch'

    it 'should run successful command' do
      File.exist?(sandbox('first')).should be_true
    end
  end

  %w(TERM INT).each do |signal|
    describe "when SIG#{signal} sent" do 
      before :each do
        starling_send(:commands => [['kill', '-s', signal, @shell_elf_pid.to_s], ['touch', sandbox('done')]])
        starling_send(:command => ['touch', sandbox('never_get_here')])
        pid_wait(@shell_elf_pid)
        @shell_elf_pid = nil
      end

      it 'should trap the signal and complete current command before exiting' do
        File.exist?(sandbox('done')).should be_true
      end

      it 'should not run any further commands' do
        File.exist?(sandbox('never_get_here')).should be_false
      end
    end
  end
end
