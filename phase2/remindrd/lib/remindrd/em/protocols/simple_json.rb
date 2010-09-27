require 'json'
require 'json/add/core'

module Remindrd
  module EM
    module Protocols
      module SimpleJSON
      
        def load msg
          JSON.load(msg)
        end

        def dump obj
          obj.to_json
        end
        
      end
    end
  end
end