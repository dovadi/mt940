require 'helper'

class TestMt940Abnamro < Test::Unit::TestCase

  def setup
    file_name = File.dirname(__FILE__) + '/fixtures/abnamro.txt'
    @transactions = MT940::Base.transactions(file_name)
    @transaction = @transactions.first
  end
  
  should 'have the correct number of transactions' do
    assert_equal 10, @transactions.size
  end

  context 'Transaction' do
    should 'have a bank_account' do
      assert_equal '517852257', @transaction.bank_account
    end

    should 'have an amount' do
      assert_equal -9.00, @transaction.amount
    end

    should 'have a description' do
      assert_equal 'GIRO   428428 KPN - DIGITENNE    BETALINGSKENM.  000000042188659 5314606715                       BETREFT FACTUUR D.D. 20-05-2011 INCL. 1,44 BTW', @transaction.description
    end
  end

end
