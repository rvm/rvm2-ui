require 'test_helper'
require 'plugins/rvm2/ui/output/fake'

describe Rvm2::Ui::Output::Fake do
  subject do
    Rvm2::Ui::Output::Fake.new(Pluginator.find("rvm2", extends: [:first_class]))
  end

  it "adds messages" do
    subject.root.list.must_equal([])
    subject.log("Test me 1")
    subject.root.list.size.must_equal(1)
    subject.log("Test me 2")
    subject.root.list.size.must_equal(2)
    subject.root.list.map(&:message).must_equal(["Test me 1", "Test me 2"])
  end

  it "adds groups" do
    subject.root.list.must_equal([])
    subject.start("Group 1")
    subject.finish(true)
    subject.root.list.size.must_equal(1)
    subject.start("Group 2")
    subject.finish(false)
    subject.root.list.size.must_equal(2)
    subject.root.list.map(&:message).must_equal(["Group 1", "Group 2"])
    subject.root.list.map(&:status).must_equal([true, false])
  end

  it "nests groups and messages" do
    subject.root.list.must_equal([])
    subject.start("Group 1")
    subject.log("Test me 1")
    subject.start("Group 2")
    subject.finish(false)
    subject.finish(true)
    subject.root.list.size.must_equal(1)
    subject.root.list[0].message.must_equal("Group 1")
    subject.root.list[0].status.must_equal(true)
    subject.root.list[0].list.size.must_equal(2)
    subject.root.list[0].list[0].message.must_equal("Test me 1")
    subject.root.list[0].list[1].message.must_equal("Group 2")
    subject.root.list[0].list[1].status.must_equal(false)
  end

  it "adds stdout writes" do
    subject.stdout.write("Example 1")
    subject.root.list.size.must_equal(1)
    subject.root.list[0].message.must_equal("Example 1")
  end

  it "adds groups stdout writes" do
    subject.start("Group 1")
    subject.stdout.write("Example 1")
    subject.finish(true)
    subject.stderr.write("Example 1")
    subject.root.list.size.must_equal(2)
    subject.root.list[0].message.must_equal("Group 1")
    subject.root.list[0].status.must_equal(true)
    subject.root.list[0].list.size.must_equal(1)
    subject.root.list[0].list[0].message.must_equal("Example 1")
    subject.root.list[0].list[0].type.must_equal(:stdout)
    subject.root.list[1].message.must_equal("Example 1")
    subject.root.list[1].type.must_equal(:stderr)
  end

end
