require 'test_helper'
require 'rvm2/ui'

describe Rvm2::Ui do
  it "gets instance of single" do
    Rvm2::Ui.get.class.name.must_equal("Rvm2::Ui::Single")
  end
end
