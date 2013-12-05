require 'test_helper'
require 'plugins/rvm2/ui/output/console'
require 'stringio'

describe Rvm2::Ui::Output::Console do
  before do
    @stdout = StringIO.new
    @stderr = StringIO.new
  end

  subject do
    Rvm2::Ui::Output::Console.new(@stdout, @stderr)
  end

  it "adds messages" do
    subject.log("Test me 1")
    subject.log("Test me 2")
    @stdout.string.must_equal(<<-EXPECTED)
Test me 1
Test me 2
    EXPECTED
  end

  it "adds groups" do
    subject.start("Group 1")
    subject.finish(true)
    subject.start("Group 2")
    subject.finish(false)
    @stdout.string.must_equal(<<-EXPECTED)
[ ] Group 1\r[v] Group 1
[ ] Group 2\r[x] Group 2
    EXPECTED
  end

  it "nests groups and messages" do
    subject.start("Group 1")
    subject.log("Test me 1")
    subject.start("Group 2")
    subject.finish(false)
    subject.start("Group 3")
    subject.log("Test me 2")
    subject.finish(true)
    subject.finish(true)
    @stdout.string.must_equal(<<-EXPECTED)
[ ] Group 1
  Test me 1
  [ ] Group 2\r  [x] Group 2
  [ ] Group 3
    Test me 2
\r  [v] Group 3
\r[v] Group 1
    EXPECTED
  end

  it "adds stdout writes" do
    subject.stdout.puts("Example 1")
    @stdout.string.must_equal(<<-EXPECTED)
Example 1
    EXPECTED
  end

  it "adds groups stdout writes" do
    subject.start("Group 1")
    subject.stdout.puts("Example 1")
    subject.finish(true)
    @stderr.string.must_equal("")
    subject.stderr.puts("Example 2")
    @stdout.string.must_equal(<<-EXPECTED)
[ ] Group 1
  Example 1
\r[v] Group 1
    EXPECTED
    @stderr.string.must_equal(<<-EXPECTED)
Example 2
    EXPECTED
  end

end
