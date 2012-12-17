require 'helper'

class TestMt940Rabobank < Test::Unit::TestCase

  def setup
    file_name = File.dirname(__FILE__) + '/fixtures/rabobank.txt'
    @transactions = MT940::Base.transactions(file_name)
    @transaction = @transactions.first
    @statements = MT940::Base.statements(file_name)
    @statement = @statements.first
  end

  should 'have the correct number of transactions' do
    assert_equal 3, @transactions.size
  end

  should 'have the correct number of statements' do
    assert_equal 3, @statements.size
  end


  context 'Transaction' do
    should 'have a bank_account' do
      assert_equal '129199348', @transaction.bank_account
    end

    context 'Contra account' do
      should 'be determined in case of a GIRO account' do
        assert_equal '121470966', @transaction.contra_account
      end

      should 'be determined in case of a regular bank' do
        assert_equal '733959555', @transactions[1].contra_account
      end

      should 'be determined in case of a NONREF' do
        assert_equal 'NONREF', @transactions.last.contra_account
      end
    end

    should 'have an amount' do
      assert_equal -1213.28, @transaction.amount
    end

    should 'have a currency' do
      assert_equal 'EUR', @transaction.currency
    end

    should 'have a contra_account_owner' do
      assert_equal 'W.P. Jansen', @transaction.contra_account_owner
    end

    should 'have a description' do
      assert_equal 'Terugboeking NIET AKKOORD MET AFSCHRIJVING KOSTEN KINDEROPVANG JUNI 20095731', @transaction.description
    end

    should 'have a date' do
      assert_equal Date.new(2011,5,27), @transaction.date
    end

    should 'return its bank' do
      assert_equal 'Rabobank', @transaction.bank
    end

  end

  context 'Statements' do
    should 'have a number' do
      assert_equal 0, @statement.number
    end

    should 'have a sequence' do
      assert_equal 0, @statement.sequence
    end

    should 'have a bank_account' do
      assert_equal '129199348', @statement.bank_account
    end

    should 'have an opening_balance_amount' do
      assert_equal 473.17, @statement.opening_balance_amount
    end

    should 'have an opening_balance_date' do
      assert_equal Date.new(2011, 6, 14), @statement.opening_balance_date
    end

    should 'have an opening_balance_currency' do
      assert_equal 'EUR', @statement.opening_balance_currency
    end

    should 'have an closing_balance_amount' do
      assert_equal -740.11, @statement.closing_balance_amount
    end

    should 'have an closing_balance_date' do
      assert_equal Date.new(2011, 6, 15), @statement.closing_balance_date
    end

    should 'have an closing_balance_currency' do
      assert_equal 'EUR', @statement.closing_balance_currency
    end

    should 'have valid amount' do
      assert_equal true, @statement.amount_valid
    end
  end

end
