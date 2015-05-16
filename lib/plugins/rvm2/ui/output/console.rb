require 'io/console'

module Rvm2
  module Ui
    module Output
      class Console

        module ConsoleIO
          attr_accessor :was_new_line

          def console_parent=(value)
            @was_new_line = true
            @console_parent = value
          end

          def write(string)
            super("\n") if !@was_new_line and !string.start_with?("\r")
            super(indent(string))
            @was_new_line = true
          end

          def indent(string)
            if levels > 0
              ends_with_n = string.end_with?("\n")
              string = string.split(/\n/).map do |s|
                s.sub(/^(\r?)/,"\\1#{"  "*levels}")
              end.join("\n")
              string << "\n" if ends_with_n
            end
            string
          end

          def levels
            @console_parent.levels
          end

          def winsize
            rows, columns = super
            [rows, columns - levels*2]
          rescue
            [0,0]
          end
        end

        attr_reader :stdout, :stderr

        def levels
          @names.size
        end

        def initialize(stdout = $stdout, stderr = $stderr)
          @stdout = stdout.extend(ConsoleIO)
          @stdout.console_parent = self
          @stderr = stderr.extend(ConsoleIO)
          @stderr.console_parent = self
          @names  = []
        end

        def start(name)
          @stdout.write(group_message(name, " "))
          @stdout.was_new_line = false
          @names.push(name)
        end

        def finish(status)
          name = @names.pop
          @stdout.puts("\r#{group_message(name, status ? "v" : "x")}")
        end

        def log(message, type = :log)
          case type
          when :log
            @stdout.puts(message)
          when :warn
            @stdout.puts("Warning: #{message}")
          when :warn_important
            @stdout.puts("WARNING! #{message}")
          when :error
            @stderr.puts("Error: #{message}")
          else
            @stdout.puts("#{type.to_s.capitalize}: #{message}")
          end
        end

      private

        def group_message(name, result)
          "[#{result}] #{name}"
        end

      end
    end
  end
end
