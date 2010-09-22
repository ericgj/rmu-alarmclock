require File.join(File.dirname(__FILE__),'..','helper')

require 'em_server'


describe Remindr::Server, 'receives valid command' do

  before do
    # stub EM.add_timer block
    module EventMachine
      def self.add_timer(sec, &blk)
        sleep(sec); blk.call
      end
    end
  end
  
  after do
    # reset EventMachine
    load 'eventmachine.rb'
  end
  
  it 'should throw each_reminder with reminder matching received message' do

    @reminder = Reminder.new({'start_at' => Time.now + 1})
    EmSpecHelper.stub_connection(Remindr::Server) do |conn|
      conn.each_reminder do |r|
        r.should.not.be.nil
        r.each_pair {|k, v| v.should.eql @reminder[k]}
      end
      conn.unparseable_message do |cmd|
        should.flunk "Command unparseable: #{cmd}"
      end
      conn.invalid_message do |msg|
        should.flunk "Invalid message: #{msg}"
      end
      conn.receive_data(@reminder.to_json + "\n\r")
    end
  
  end
   
end

describe Remindr::Server, 'receives unparseable command' do

  it 'should throw unparseable_command with message' do
    @reminder = {'hello' => 'world', 
                 'unparseable' => 'message', 
                 'created_at' => Time.now}.to_json
    EmSpecHelper.stub_connection(Remindr::Server) do |conn|
      conn.each_reminder do |r|
        should.flunk "Command parsed: #{r.to_json}"
      end
      conn.unparseable_message do |cmd|
        cmd.chomp.should.eql @reminder.chomp
      end
      conn.invalid_message do |msg|
        should.flunk "Command unparseable: #{cmd}"
      end
      conn.receive_data(@reminder + "\n\r")
    end
  end
  
end

describe Remindr::Server, 'receives invalid message format' do

  it 'should throw invalid_message with message' do
    @reminder = "invalid message"
    EmSpecHelper.stub_connection(Remindr::Server) do |conn|
      conn.each_reminder do |r|
        should.flunk "Command parsed: #{r.to_json}"
      end
      conn.unparseable_message do |cmd|
        should.flunk "Command unparseable: #{cmd}"
      end
      conn.invalid_message do |msg|
        msg.chomp.should.eql @reminder.chomp
      end
      conn.receive_data(@reminder + "\n\r")
    end
  end
  
end
