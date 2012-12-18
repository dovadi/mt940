require 'helper'

class TestMt940Ing < Test::Unit::TestCase

  def setup
    file_name = File.dirname(__FILE__) + '/fixtures/ing.txt'
    @transactions = MT940::Base.transactions(file_name)
    @transaction = @transactions.first
    @statements = MT940::Base.statements(file_name)
    @statement = @statements.first
  end
  
  should 'have the correct number of transactions' do
    assert_equal 6, @transactions.size
  end

  should 'have the correct number of statements' do
    assert_equal 1, @statements.size
  end


  context 'Transaction' do
    should 'have a bank_account' do
      assert_equal '001234567', @transaction.bank_account
    end

    should 'have an amount' do
      assert_equal -25.03, @transaction.amount
    end

    should 'have a currency' do
      assert_equal 'EUR', @transaction.currency
    end

    should 'have a date' do
      assert_equal Date.new(2010,7,22), @transaction.date
    end

    should 'return its bank' do
      assert_equal 'Ing', @transaction.bank
    end

    should 'have a description' do
      assert_equal 'EJ46GREENP100610T1456 CLIEOP TMG GPHONGKONG AMSTERDAM', @transactions.last.description
    end

    should 'return the contra_account' do
      assert_equal '123456789', @transactions.last.contra_account
    end

  end

  context 'Statements' do
    #should 'have a number' do
    #  assert_equal 19321, @statement.number
    #end

    #should 'have a sequence' do
    #  assert_equal 1, @statement.sequence
    #end

    should 'have a bank_account' do
      assert_equal '001234567', @statement.bank_account
    end

    should 'have an opening_balance_amount' do
      assert_equal 0.0, @statement.opening_balance_amount
    end

    should 'have an opening_balance_date' do
      assert_equal Date.new(2010,7,22), @statement.opening_balance_date
    end

    should 'have an opening_balance_currency' do
      assert_equal 'EUR', @statement.opening_balance_currency
    end

    should 'have an closing_balance_amount' do
      assert_equal -46.59, @statement.closing_balance_amount
    end

    should 'have an closing_balance_date' do
      assert_equal Date.new(2010,7,23), @statement.closing_balance_date
    end

    should 'have an closing_balance_currency' do
      assert_equal 'EUR', @statement.closing_balance_currency
    end

    should 'have valid amount' do
      assert_equal true, @statement.amount_valid
    end
  end


end
