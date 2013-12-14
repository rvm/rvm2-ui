require 'test_helper'
require 'rvm2/ui/single'

describe Rvm2::Ui::Single do
  subject do
    Rvm2::Ui::Single
  end

  it "loads console by default" do
    subject.new.handler.class.name.must_equal("Rvm2::Ui::Output::Console")
  end

  it "handles commands" do
    @obj = subject.new(:fake)
    @obj.command("test true" ){ true  }.must_equal(true)
    @obj.command("test false"){ false }.must_equal(false)
    @obj.handler.root.list.map(&:message).must_equal(["test true", "test false"])
  end

end
