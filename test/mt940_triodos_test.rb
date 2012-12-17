require 'helper'

class TestMt940Triodos < Test::Unit::TestCase

  def setup
    file_name = File.dirname(__FILE__) + '/fixtures/triodos.txt'
    @transactions = MT940::Base.transactions(file_name)
    @transaction = @transactions.first
    @statements = MT940::Base.statements(file_name)
    @statement = @statements.first
  end
  
  should 'have the correct number of transactions' do
    assert_equal 2, @transactions.size
  end

  should 'have the correct number of statements' do
    assert_equal 1, @statements.size
  end


  context 'Transaction' do
    should 'have a bank_account' do
      assert_equal '390123456', @transaction.bank_account
    end

    should 'have an amount' do
      assert_equal -15.7, @transaction.amount
    end

    should 'have a currency' do
      assert_equal 'EUR', @transaction.currency
    end

    should 'have a description' do
      assert_equal 'ALGEMENE TUSSENREKENING KOSTEN VAN 01-10-2010 TOT EN M ET 31-12-20100390123456', @transaction.description
    end

    should 'have a date' do
      assert_equal Date.new(2011,1,1), @transaction.date
    end

    should 'return its bank' do
      assert_equal 'Triodos', @transaction.bank
    end

    should 'return the contra_account' do
      assert_equal '987654321', @transaction.contra_account
    end

  end

  context 'Statements' do
    #should 'have a number' do
    #  assert_equal 19321, @statement.number
    #end
    #
    #should 'have a sequence' do
    #  assert_equal 1, @statement.sequence
    #end

    should 'have a bank_account' do
      assert_equal '390123456', @statement.bank_account
    end

    should 'have an opening_balance_amount' do
      assert_equal 4975.09, @statement.opening_balance_amount
    end

    should 'have an opening_balance_date' do
      assert_equal Date.new(2011,1,1), @statement.opening_balance_date
    end

    should 'have an opening_balance_currency' do
      assert_equal 'EUR', @statement.opening_balance_currency
    end

    should 'have an closing_balance_amount' do
      assert_equal 4259.39, @statement.closing_balance_amount
    end

    should 'have an closing_balance_date' do
      assert_equal Date.new(2011,2,1), @statement.closing_balance_date
    end

    should 'have an closing_balance_currency' do
      assert_equal 'EUR', @statement.closing_balance_currency
    end

    should 'have valid amount' do
      assert_equal true, @statement.amount_valid
    end
  end


end
