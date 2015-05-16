module Rvm2
  module Ui
    module Progress
      module Console
        class ClosedText

          def initialize(rvm2_plugins, parent, name, size, start)
            @rvm2_plugins = rvm2_plugins
            @parent  = parent
            @name    = name
            @size    = size
            change(start)
          end

          def change(size)
            @parent.stdout.write("\r#{@name}: #{size}/#{@size}")
            @parent.stdout.was_new_line = false
          end

          def finish(message = "Finished")
            @parent.stdout.puts("\r#{@name}: #{message}")
          end

        end
      end
    end
  end
end
