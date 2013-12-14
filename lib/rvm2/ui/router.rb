module Rvm2
  module Ui
    class Router

      def initialize(rvm2_plugins = nil)
        @rvm2_plugins = rvm2_plugins || Pluginator.find("rvm2", extends: %i{first_class})
        @handlers = []
      end

      def add(type = :console, *args)
        @handlers << @rvm2_plugins.first_class!('ui/output', type).new(*args)
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
        raise "Not implemented yet"
      end

      def stderr
        raise "Not implemented yet"
      end

    end
  end
end
