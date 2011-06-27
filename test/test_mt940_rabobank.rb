require 'helper'

class TestMt940Rabobank < Test::Unit::TestCase

  def setup
    file_name = File.dirname(__FILE__) + '/fixtures/rabobank.txt'
    @transactions = MT940::Base.transactions(file_name)
    @transaction = @transactions.first
  end
  
  should 'have the correct number of transactions' do
    assert_equal 2, @transactions.size
  end

  context 'Transaction' do
    should 'have a bank_account' do
      assert_equal '129199348', @transaction.bank_account
    end

    should 'have a contra_account' do
      assert_equal 'P005675159', @transaction.contra_account
    end

    should 'have an amount' do
      assert_equal -77.35, @transaction.amount
    end

    should 'have a contra_account_name' do
      assert_equal 'Uitgeverij De Druif', @transaction.contra_account_name
    end

    should 'have a description' do
      assert_equal 'Factuurnummer 234578', @transaction.description
    end

    should 'have a date' do
      assert_equal Date.new(2011,6,15), @transaction.date
    end

  end

end
