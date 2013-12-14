require 'test_helper'
require 'rvm2/ui'

describe Rvm2::Ui do
  it "gets instance of single" do
    Rvm2::Ui.get.class.name.must_equal("Rvm2::Ui::Single")
  end
  it "gets instance of multi" do
    Rvm2::Ui.multi.class.name.must_equal("Rvm2::Ui::Multi")
  end
end
