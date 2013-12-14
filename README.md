# Rvm2::Ui

[![Gem Version](https://badge.fury.io/rb/rvm2-ui.png)](http://rubygems.org/gems/rvm2-ui)
[![Code Climate](https://codeclimate.com/github/rvm/rvm2-ui.png)](https://codeclimate.com/github/rvm/rvm2-ui)
[![Coverage Status](https://coveralls.io/repos/rvm/rvm2-ui/badge.png?branch=master)](https://coveralls.io/r/rvm/rvm2-ui?branch=master)
[![Build Status](https://travis-ci.org/rvm/rvm2-ui.png?branch=master)](https://travis-ci.org/rvm/rvm2-ui)
[![Dependency Status](https://gemnasium.com/rvm/rvm2-ui.png)](https://gemnasium.com/rvm/rvm2-ui)
[![Documentation](http://b.repl.ca/v1/yard-docs-blue.png)](http://rubydoc.info/gems/rvm2-ui/frames)

## Example output

Using `:console` handler:

    [ ] Command 1
      Log output 1
      [x] Command 2
      [ ] Command 3
        Log output 2
      [v] Command 3
    [v] Command 1

## Installation

Get the gem:

    gem install rvm2-ui

Load it:

    require 'rvm2/ui'

## Usage

Different handlers can be loaded using `pluginator` group `rvm2` type `ui/output`:

    Rvm2::Ui.get(type = :console, rvm2_plugins = nil, *args)

the `args` will be passed to the handler constructor.

To get the default console output:

    @ui = Rvm2::Ui.get

## Wrapping code blocks

The `command` will produce checklist like item:

   @ui.command('display name') do
     do_something
   end

Example output with `:console` output - before finish:

    [ ] Group 1

after finish:

    [v] Group 1

## Logging output

The `log` allows giving messages, warnings and errors to user:

    log(message, type = :log)
Supported types are `:log`, `:warn`, `:warn_important`, `:error`, any other type might be supported
or should be handled as `:log` with the capitalized `type` as prefix.

Example:

    @ui.log("something went wrong", :error)

Would produce with console:

    Error: something went wrong

## Handling extra outputs

In some cases like running shell commands an `stdout` and `stderr` objects are available with `IO`
interface allowing proper output handling (not injecting text in random places):

    @ui.command("test") do
      @ui.stderr.puts("debugging output")
    end

would produce with `:console`:

    [ ] test
      debugging output
    [v] test

## Combining multiple outputs

In some cases it might be useful to send the same output to different targets like UI and log:

    Rvm2::UI.multi(rvm2_plugins)

Example use:

    @ui = Rvm2::UI.multi
    @ui.add(:console)
    @ui.add(:log, "my_app.log")
    @ui.log("text")
    @ui.remove # removes the last added logger

Example - temporarily use logger:

    @ui = Rvm2::UI.multi
    @ui.add(:console)
    @ui.with(:log, "my_app.log") do
      @ui.log("text")
    end

In bot examples the output will be written to both standard output and log file.
