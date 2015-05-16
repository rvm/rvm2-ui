require_relative "console"

module Rvm2
  module Ui
    module Output
      class Log < Console
        attr_reader :file_name
        def initialize(rvm2_plugins, file_name, flags = "w")
          @rvm2_plugins = rvm2_plugins
          @file_name = file_name
          @file = File.new(@file_name, flags)
          super(@file, @file)
        end
        def finalize
          @file.close
        end
      end
    end
  end
end
