module Rvm2
  module Ui
    module Output
      class Console

        def initialize(stdout = $stdout, stderr = $stderr)
          @stdout = stdout
          @stderr = stderr
          @names  = []
          @was_new_line = false
        end

        def start(name)
          @was_new_line = false
          print_leveled(@stdout, group_message(name), new_line: false)
          @names.push(name)
        end

        def finish(status)
          name = @names.pop
          print_leveled(@stdout, group_message(name), reset: true)
        end

        def log(message, type = :log)
          print_leveled(@stdout, message)
        end

      private

        def group_message(name)
          "[ ] #{name}"
        end

        def print_leveled(output, message, new_line: true, reset: false)
          output.print("\r") if reset && !@was_new_line
          output.print("  "*@names.size*2) if @names.size > 0
          output.print(message)
          output.print("\n") if new_line
          @was_new_line ||= new_line
        end

      end
    end
  end
end
