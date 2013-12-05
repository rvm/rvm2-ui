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
    @stdout.string.must_equal("Test me 1\nTest me 2\n")
  end
end
