require 'test_helper'
require 'plugins/rvm2/ui/output/log'
require 'tempfile'

describe Rvm2::Ui::Output::Log do
  before do
    @tempfile = Tempfile.new("rvm2-ui-output-log-test")
    @tempfile.close
  end
  after do
    @tempfile.unlink
  end
  subject do
    Rvm2::Ui::Output::Log.new(
      Pluginator.find("rvm2", extends: [:first_class]),
      @tempfile.path
    )
  end

  it "adds messages" do
    subject.log("Test me 1")
    subject.finalize
    File.open(@tempfile.path, "r") do |file|
      file.read.must_equal(<<-EXPECTED)
Test me 1
      EXPECTED
    end
  end
end
