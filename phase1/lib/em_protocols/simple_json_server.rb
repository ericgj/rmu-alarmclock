require 'eventmachine'
require 'json'
require 'json/add/core'

# This is a generic EM server for handling simple JSON messages
# with no header lines.
# Subclasses define #receive_message for parsed message handling
#   and can also override the basic JSON parse.

module Remindr
  module EMProtocols
    module SimpleJSONServer

      def post_init
        @buffer = BufferedTokenizer.new("\r")
      end
      
      def unparseable_message(&blk)
        @unparseable_message_callback = blk
      end
      
      def invalid_message(&blk)
        @invalid_message_callback = blk
      end
      
      def receive_data data
        @buffer.extract(data).each do |line|
          receive_line line
        end
      end

      # callback defined in subclass
      def receive_message(msg)
      end
      
      # default parse is the standard JSON parse
      def parse line
        JSON.parse(line)
      end
      
      protected
      
      def receive_line line
        if line[0,1] == '{'
          begin
            receive_message parse(line)
          rescue
            @unparseable_message_callback.call(line) \
              if @unparseable_message_callback
          end
        else
          @invalid_message_callback.call(line) \
            if @invalid_message_callback
        end
      end
      
    end
  end
end


