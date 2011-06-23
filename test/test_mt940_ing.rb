require 'helper'

class TestMt940Ing < Test::Unit::TestCase

  def setup
    file_name = File.dirname(__FILE__) + '/fixtures/ing.txt'
    transactions = MT940::ING.get_transactions(file_name)
    @transaction = transactions.first
  end

  context 'Transaction' do
    should 'have a bank_account' do
      assert_equal '0001234567', @transaction.bank_account
    end

    should 'have a contra_account' do
      assert_equal '0111111111', @transaction.contra_account
    end

    should 'have an amount' do
      assert_equal -25.03, @transaction.amount
    end
    
    should 'have a description' do
      assert_equal 'ING Bank N.V. inzake TEST EJ004GREENP29052010T1137', @transaction.description
    end
  end

end
