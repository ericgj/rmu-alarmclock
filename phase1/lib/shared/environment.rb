# load/dump environment settings from YAML

module Remindr
class Environment < Struct.new(:server, :client, :alarm)

  require 'yaml'
  
  def self.load(file = '.remindr')
    file = File.join(ENV['HOME'],file)  
    opts = if file && File.exists?(file)
            YAML::load(open(file))
           else
            {}
           end
    env = new(opts)
    env.file = file
    env
  end
  
  def initialize(hash = {})
    self.server = Server.new(hash['server'])
    #client = Client.new(hash['client'])
    self.alarm = Alarm.new(hash['alarm'])
  end
  
  def file=(to_file)
    @to_file = to_file
  end
  
  def to_h
    hash = {};
    hash['server'] = self.server.to_h
    hash['alarm'] = self.alarm.to_h
    hash
  end
  
  def configure
    Signal.trap("INT") { puts "Exited." } 
    write_on_exit = false

    unless self.server.host && self.server.port
      puts "Configuring Reminder server..."
      unless self.server.host
        print "> What is the server host address or URL? [localhost] "
        self.server.host = gets.chomp 
        self.server.host = 'localhost' if self.server.host.empty?
        write_on_exit = true
      end
      unless self.server.port
        print "> What is the server port? [5997] "
        self.server.port = gets.chomp.to_i 
        self.server.port = 5997 if self.server.port = 0
        write_on_exit = true
      end
    end
    
    unless self.alarm.host && self.alarm.port && self.alarm.sound
      puts "Configuring Alarm server..."
      unless self.alarm.host
        print "> What is the alarm host address or URL? [localhost] "
        self.alarm.host = gets.chomp 
        self.alarm.host = 'localhost' if self.alarm.host.empty?
        write_on_exit = true
      end
      unless self.alarm.port
        print "> What is the alarm port? [5998] "
        self.alarm.port = gets.chomp.to_i
        self.alarm.port = 5998 if self.alarm.port = 0
        write_on_exit = true
      end
      unless self.alarm.sound
        print "> What is the alarm sound file? [lib/em/rsc/ringin.wav] "
        self.alarm.sound = gets.chomp
        self.alarm.sound = 'rsc/ringin.wav' if self.alarm.sound.empty?
        write_on_exit = true
      end
    end
    
    if write_on_exit && @to_file
      File.open( @to_file, 'w' ) do |out|
         YAML.dump( to_h, out )
      end
    end
    self
    
  end
  
  class Server < Struct.new(:host, :port)
  
    def initialize(hash = {})
      hash ||= {}
      hash.each_pair {|k,v| self.__send__("#{k}=".to_sym, v)}
    end
    
    def to_h
      hash = {}
      each_pair {|k, v| hash[k.to_s] = v}
      hash
    end
    
  end
  
  class Alarm < Struct.new(:host, :port, :sound)
  
    def initialize(hash = {})
      hash ||= {}
      hash.each_pair {|k,v| self.__send__("#{k}=".to_sym, v)}
    end
    
    def to_h
      hash = {}
      each_pair {|k, v| hash[k.to_s] = v}
      hash
    end
    
  end
  
end
end