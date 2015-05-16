require 'test_helper'
require 'plugins/rvm2/ui/output/console'
require 'plugins/rvm2/ui/progress/console/open_text'
require 'stringio'

describe Rvm2::Ui::Progress::Console::OpenText do
  before do
    @stdout     = StringIO.new
    @stderr     = StringIO.new
    @pluginator = Pluginator.find("rvm2", extends: %i{first_class})
    @console    = Rvm2::Ui::Output::Console.new(@pluginator, @stdout, @stderr)
  end

  subject do
    Rvm2::Ui::Progress::Console::OpenText
  end

  it "starts at new line" do
    @console.log("test")
    test = subject.new(@pluginator, @console, "TestMe", 0)
    @stdout.string.must_equal("test\n\rTestMe: 0")
    @stderr.string.must_equal("")
  end

  it "starts progress with 0" do
    test = subject.new(@pluginator, @console, "TestMe", 0)
    @stdout.string.must_equal("\rTestMe: 0")
    @stderr.string.must_equal("")
  end

  it "starts progress with 1" do
    test = subject.new(@pluginator, @console, "TestMe", 1)
    @stdout.string.must_equal("\rTestMe: 1")
    @stderr.string.must_equal("")
  end

  it "adds new size" do
    test = subject.new(@pluginator, @console, "TestMe", 0)
    test.change(2)
    @stdout.string.must_equal("\rTestMe: 0\rTestMe: 2")
    @stderr.string.must_equal("")
  end

  it "finishes without message" do
    test = subject.new(@pluginator, @console, "TestMe", 0)
    test.finish
    @stdout.string.must_equal("\rTestMe: 0\rTestMe: Finished\n")
    @stderr.string.must_equal("")
  end

  it "finishes with message" do
    test = subject.new(@pluginator, @console, "TestMe", 0)
    test.finish("Done")
    @stdout.string.must_equal("\rTestMe: 0\rTestMe: Done\n")
    @stderr.string.must_equal("")
  end

end
