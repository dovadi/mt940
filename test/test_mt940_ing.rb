require 'helper'

class TestMt940Ing < Test::Unit::TestCase

  def setup
    file_name = File.dirname(__FILE__) + '/fixtures/ing.txt'
    @transactions = MT940::Base.transactions(file_name)
    @transaction = @transactions.first
  end
  
  should 'have the correct number of transactions' do
    assert_equal 6, @transactions.size
  end

  context 'Transaction' do
    should 'have a bank_account' do
      assert_equal '0001234567', @transaction.bank_account
    end

    should 'have an amount' do
      assert_equal -25.03, @transaction.amount
    end

    should 'have a description' do
      assert_equal 'RC AFREKENING BETALINGSVERKEER BETREFT REKENING 4715589 PERIODE: 01-10-2010 / 31-12-2010 ING Bank N.V. tarifering ING', @transaction.description
    end

    should 'have a date' do
      assert_equal Date.new(2010,7,22), @transaction.date
    end
  end

end
