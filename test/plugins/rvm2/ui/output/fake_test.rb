require 'test_helper'
require 'plugins/rvm2/ui/output/fake'

describe Rvm2::Ui::Output::Fake do
  subject do
    Rvm2::Ui::Output::Fake.new
  end
  it "adds messages" do
    subject.root.list.must_equal([])
    subject.log("Test me 1")
    subject.root.list.size.must_equal(1)
    subject.log("Test me 2")
    subject.root.list.size.must_equal(2)
    subject.root.list.map(&:message).must_equal(["Test me 1", "Test me 2"])
  end
end
