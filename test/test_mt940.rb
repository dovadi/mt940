require 'helper'

class TestMt940 < Test::Unit::TestCase

  def setup
    @file_name = File.dirname(__FILE__) + '/fixtures/ing.txt'
  end

  should 'raise a NoMethodError if not implemented' do
    assert_raise(NoMethodError) { MT940::Base.get_transactions(@file_name) }
  end

end
