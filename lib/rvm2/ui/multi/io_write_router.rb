module Rvm2
  module Ui
    class Multi
      class IoWriteRouter

        def initialize(parent, type)
          @parent = parent
          @type   = type
        end
        def write(*args)
          @parent.handlers.each{|h| h.send(@type).write(*args) }
        end
        def <<(*args)
          @parent.handlers.each{|h| h.send(@type).<<(*args) }
        end
        def print(*args)
          @parent.handlers.each{|h| h.send(@type).print(*args) }
        end
        def printf(*args)
          @parent.handlers.each{|h| h.send(@type).printf(*args) }
        end
        def puts(*args)
          @parent.handlers.each{|h| h.send(@type).puts(*args) }
        end
        def write_nonblock(*args)
          @parent.handlers.each{|h| h.send(@type).write_nonblock(*args) }
        end

      end
    end
  end
end
