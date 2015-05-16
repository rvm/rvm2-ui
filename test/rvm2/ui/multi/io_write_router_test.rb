require 'test_helper'
require 'rvm2/ui/multi/io_write_router'
require 'plugins/rvm2/ui/output/fake'

class HandlersParent
  attr_reader :handlers
  def initialize
    pluginator = Pluginator.find("rvm2", extends: %i{first_class})
    @handlers = [Rvm2::Ui::Output::Fake.new(pluginator), Rvm2::Ui::Output::Fake.new(pluginator)]
  end
end

describe Rvm2::Ui::Multi::IoWriteRouter do
  before do
    @parent = HandlersParent.new
  end

  subject do
    Rvm2::Ui::Multi::IoWriteRouter.new(@parent, :stdout)
  end

  it "supports write" do
    subject.write("test 1")
    @parent.handlers[0].root.list.map(&:message).must_equal(["test 1"])
    @parent.handlers[1].root.list.map(&:message).must_equal(["test 1"])
  end

  it "supports <<" do
    subject << "test 1"
    @parent.handlers[0].root.list.map(&:message).must_equal(["test 1"])
    @parent.handlers[1].root.list.map(&:message).must_equal(["test 1"])
  end

  it "supports print" do
    subject.print("test 1")
    @parent.handlers[0].root.list.map(&:message).must_equal(["test 1"])
    @parent.handlers[1].root.list.map(&:message).must_equal(["test 1"])
  end

  it "supports printf" do
    subject.printf("test 1")
    @parent.handlers[0].root.list.map(&:message).must_equal(["test 1"])
    @parent.handlers[1].root.list.map(&:message).must_equal(["test 1"])
  end

  it "supports puts" do
    subject.puts("test 1")
    @parent.handlers[0].root.list.map(&:message).must_equal(["test 1", "\n"])
    @parent.handlers[1].root.list.map(&:message).must_equal(["test 1", "\n"])
  end

  it "supports write_nonblock" do
    subject.write_nonblock("test 1")
    @parent.handlers[0].root.list.map(&:message).must_equal(["test 1"])
    @parent.handlers[1].root.list.map(&:message).must_equal(["test 1"])
  end

end
