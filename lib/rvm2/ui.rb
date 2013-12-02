require 'hooks'
require 'hooks/instance_hooks'

module Rvm2
  class Ui
    define_hooks :on_start, :on_finish, :on_log

    # ui.command "bla" { do_something; }
    def command(name, &block)
      raise "No block given" unless block_given?
      run_hook(:on_start,  name)
      block.call
      run_hook(:on_finish, name)
    end

    # ui.log 'message'
    # ui.log 'message', :important
    # standard types => :log, :warn, :important, :error
    # in case unsupported type is used :log will be used
    def log(message, type = :log)
      run_hook(:on_log, message, type)
    end

  end
end
