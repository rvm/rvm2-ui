require 'test_helper'
require 'rvm2/ui/multi'

describe Rvm2::Ui::Multi do
  before do
    @stdout = StringIO.new
    @stderr = StringIO.new
  end

  subject do
    ui = Rvm2::Ui::Multi.new
    ui.add(:console, @stdout, @stderr)
    ui.add(:fake)
    ui
  end

  it "removes handlers" do
    subject.remove
    subject.handlers.map{|h| h.class.name }.must_equal(["Rvm2::Ui::Output::Console"])
  end

  it "supports multiple outputs" do
    subject.handlers.map{|h| h.class.name }.must_equal(["Rvm2::Ui::Output::Console", "Rvm2::Ui::Output::Fake"])
  end

  it "handles commands" do
    subject.command("test true" ){ true  }.must_equal(true)
    subject.command("test false"){ false }.must_equal(false)
    @stdout.string.must_equal(<<-EXPECTED)
[ ] test true\r[v] test true
[ ] test false\r[x] test false
EXPECTED
    subject.handlers[1].root.list.map(&:message).must_equal(["test true", "test false"])
  end

  it "handles log" do
    subject.log("test log")
    @stdout.string.must_equal(<<-EXPECTED)
test log
EXPECTED
    subject.handlers[1].root.list.map(&:message).must_equal(["test log"])
  end

  it "supports outputs" do
    subject.stdout.write("test stdout")
    subject.stderr.write("test stderr")
    @stdout.string.must_equal("test stdout")
    @stderr.string.must_equal("test stderr")
    subject.handlers[1].root.list.map(&:message).must_equal(["test stdout", "test stderr"])
    subject.handlers[1].root.list.map(&:type).must_equal([:stdout, :stderr])
  end

  it "handles temporary adding of a log" do
    subject.handlers.count.must_equal(2)
    subject.with(:fake) do
      subject.handlers.count.must_equal(3)
      subject.handlers[2].class.name.must_equal("Rvm2::Ui::Output::Fake")
    end
    subject.handlers.count.must_equal(2)
  end

end
