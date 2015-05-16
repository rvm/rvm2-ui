require 'pluginator'

module Rvm2
  module Ui
    class Single

      attr_reader :handler

      def initialize(handler = :console, rvm2_plugins = nil, *args)
        @rvm2_plugins = rvm2_plugins || Pluginator.find("rvm2", extends: %i{first_class})
        @handler = @rvm2_plugins.first_class!('ui/output', handler).new(@rvm2_plugins, *args)
      end

      # ui.command "message" { do_something; }
      def command(name, &block)
        raise "No block given" unless block_given?
        @handler.start(name)
        status = block.call
        @handler.finish(status)
        status
      end

      # ui.log 'message'
      # ui.log 'message', :important
      # standard types => :log, :warn, :important, :error
      # in case unsupported type is used :log will be used
      def log(message, type = :log)
        @handler.log(message, type)
      end

      def stdout
        @handler.stdout
      end

      def stderr
        @handler.stderr
      end

    end
  end
end
