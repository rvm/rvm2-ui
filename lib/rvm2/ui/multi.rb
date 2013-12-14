module Rvm2
  module Ui
    class Multi

      class IoRouter
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

      attr_reader :handlers

      def initialize(rvm2_plugins = nil)
        @rvm2_plugins = rvm2_plugins || Pluginator.find("rvm2", extends: %i{first_class})
        @handlers = []
      end

      def add(handler, *args)
        @handlers << @rvm2_plugins.first_class!('ui/output', handler).new(*args)
      end

      # ui.command "message" { do_something; }
      def command(name, &block)
        raise "No block given" unless block_given?
        @handlers.each {|h| h.start(name) }
        status = block.call
        @handlers.each {|h| h.finish(status) }
        status
      end

      # ui.log 'message'
      # ui.log 'message', :important
      # standard types => :log, :warn, :important, :error
      # in case unsupported type is used :log will be used
      def log(message, type = :log)
        @handlers.each {|h| h.log(message, type) }
      end

      def stdout
        @stdout ||= IoRouter.new(self, :stdout)
      end

      def stderr
        @stderr ||= IoRouter.new(self, :stderr)
      end

    end
  end
end
