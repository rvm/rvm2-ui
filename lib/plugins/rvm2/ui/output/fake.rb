module Rvm2
  module Ui
    class Fake

      class Element
        attr_reader :list, :message, :type, :parent
        def initialize(message, type = :log, parent = nil)
          @message = message
          @type    = type
          @parent  = parent
          @list    = [] unless parent.nil?
        end
      end

      attr_reader :root
      def initialize
        @root = Element.new(nil, :group, nil)
        @current = @root
      end

      def start(name)
        created = Element.new(name, :group, @current)
        @current.list << created
        @current =  created
      end

      def finish
        @current = @current.parent
      end

      def log(message, type = :log)
        @current << Element.new(message, type)
      end

    end
  end
end
