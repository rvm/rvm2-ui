module Rvm2
  module Ui
    class Router

      def initialize(type)
        @handler = ...
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
