require 'stringio'

module Rvm2
  module Ui
    module Output
      class Fake

        class Element
          attr_reader :list, :message, :type, :parent
          attr_accessor :status
          def initialize(message, type = :log, parent = nil)
            @message = message
            @type    = type
            @parent  = parent
            @list    = [] if type == :group
          end
        end

        class StringElements < StringIO
          def initialize(parent, type)
            @parent = parent
            @type = type
            super("","w")
          end
          def write(string)
            @parent.current.list << Element.new(string, @type)
          end
        end

        attr_reader :root, :current
        def initialize
          @root = Element.new(nil, :group, nil)
          @current = @root
        end

        def start(name)
          created = Element.new(name, :group, @current)
          @current.list << created
          @current =  created
        end

        def finish(status)
          @current.status = status
          @current = @current.parent
        end

        def log(message, type = :log)
          @current.list << Element.new(message, type)
        end

        def stdout
          @stdout ||= StringElements.new(self, :stdout)
        end

        def stderr
          @stderr ||= StringElements.new(self, :stderr)
        end

      end
    end
  end
end
