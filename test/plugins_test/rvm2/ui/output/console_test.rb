require 'test_helper'
require 'plugins/rvm2/ui/output/console'
require 'stringio'

module AddWinSize
  attr_accessor :winsize
end

describe Rvm2::Ui::Output::Console do
  before do
    @stdout = StringIO.new
    @stderr = StringIO.new
  end

  subject do
    Rvm2::Ui::Output::Console.new(
      Pluginator.find("rvm2", extends: %i{first_class}),
      @stdout,
      @stderr
    )
  end

  it "adds messages" do
    subject.log("Test me 1")
    subject.log("Test me 2")
    @stderr.string.must_equal("")
    @stdout.string.must_equal(<<-EXPECTED)
Test me 1
Test me 2
    EXPECTED
  end

  it "adds warnings" do
    subject.log("Test me 1", :warn)
    @stderr.string.must_equal("")
    @stdout.string.must_equal(<<-EXPECTED)
Warning: Test me 1
    EXPECTED
  end

  it "adds important warnings" do
    subject.log("Test me 1", :warn_important)
    @stderr.string.must_equal("")
    @stdout.string.must_equal(<<-EXPECTED)
WARNING! Test me 1
    EXPECTED
  end

  it "adds errors" do
    subject.log("Test me 1", :error)
    @stdout.string.must_equal("")
    @stderr.string.must_equal(<<-EXPECTED)
Error: Test me 1
    EXPECTED
  end

  it "adds custom messages" do
    subject.log("Test me 1", :custom)
    @stderr.string.must_equal("")
    @stdout.string.must_equal(<<-EXPECTED)
Custom: Test me 1
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

  it "adds grouped stdout writes" do
    subject.start("Group 1")
    subject.stdout.puts("Example 1")
    subject.finish(true)
    @stdout.string.must_equal(<<-EXPECTED)
[ ] Group 1
  Example 1
\r[v] Group 1
    EXPECTED
  end

  it "adds stderr writes" do
    subject.stderr.puts("Example 2")
    @stderr.string.must_equal(<<-EXPECTED)
Example 2
    EXPECTED
  end

  it "has no winsize when it's not available in the subject" do
    subject.stdout.winsize.must_equal(nil)
  end

  describe "ConsoleIO.winsize" do
    before do
      @stdout.extend(AddWinSize)
      @stdout.winsize = [100, 100]
    end

    it "has winsize when it's available" do
      subject.stdout.winsize.must_equal([100,100])
    end

    it "winsize is decreased on every level" do
      subject.start("one")
      subject.stdout.winsize.must_equal([100,98])
      subject.start("two")
      subject.stdout.winsize.must_equal([100,96])
    end
  end

end
