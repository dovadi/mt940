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

    context 'Description' do
      should 'have the correct description in case of a GIRO account' do
        assert_equal 'KPN - DIGITENNE    BETALINGSKENM.  000000042188659 5314606715                       BETREFT FACTUUR D.D. 20-05-2011 INCL. 1,44 BTW', @transaction.description
      end

      should 'have the correct description in case of a regular bank' do
        assert_equal 'MYCOM DEN HAAG  S-GRAVEN,PAS999', @transactions.last.description
      end
    end

    should 'have a date' do
      assert_equal Date.new(2011,5,24), @transaction.date
    end

    should 'return its bank' do
      assert_equal 'Abnamro', @transaction.bank
    end

    should 'have a currency' do
      assert_equal 'EUR', @transaction.currency
    end

    context 'Contra account' do
      should 'be determined in case of a GIRO account' do
        assert_equal '000428428', @transaction.contra_account
      end

      should 'be determined in case of a regular bank' do
        assert_equal '528939882', @transactions.last.contra_account
      end
    end
  end

end
