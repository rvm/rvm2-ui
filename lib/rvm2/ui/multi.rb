module Rvm2
  module Ui
    class Multi

      attr_reader :handlers

      def initialize(rvm2_plugins = nil)
        @rvm2_plugins = rvm2_plugins || Pluginator.find("rvm2", extends: [:first_class])
        @handlers = []
      end

      def add(handler, *args)
        @handlers << @rvm2_plugins.first_class!('ui/output', handler).new(@rvm2_plugins, *args)
      end

      def remove
        @handlers.pop
      end

      def with(handler, *args, &block)
        add(handler, *args)
        block.call
        remove
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
        @stdout ||= IoWriteRouter.new(self, :stdout)
      end

      def stderr
        @stderr ||= IoWriteRouter.new(self, :stderr)
      end

    end
  end
end

require_relative 'multi/io_write_router'
