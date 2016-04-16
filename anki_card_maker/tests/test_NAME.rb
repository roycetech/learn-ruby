require "./lib/NAME.rb"
require "test/unit"

class TestNAME < Test::Unit::TestCase

  def test_sample
        @sut = Dummy.new
    assert_equal('Hello World', @sut.hello)
  end

end

