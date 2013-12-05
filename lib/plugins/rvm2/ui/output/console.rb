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
          print_leveled(@stdout, group_message(name), new_line: false)
          @stdout.was_new_line = false
          @names.push(name)
        end

        def finish(status)
          name = @names.pop
          print_leveled(@stdout, group_message(name, status ? "v" : "x"), reset: true)
        end

        def log(message, type = :log)
          print_leveled(@stdout, message)
        end

      private

        def group_message(name, result = " ")
          "[#{result}] #{name}"
        end

        def print_leveled(output, message, new_line: true, reset: false)
          message.prepend("\r") if reset
          message.concat ("\n") if new_line
          output.write(message)
        end

      end
    end
  end
end
