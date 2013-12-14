require 'test_helper'
require 'rvm2/ui/single'

describe Rvm2::Ui::Single do
  subject do
    Rvm2::Ui::Single
  end

  it "loads console by default" do
    subject.new.handler.class.name.must_equal("Rvm2::Ui::Output::Console")
  end
end
