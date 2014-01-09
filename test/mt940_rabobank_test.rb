require 'helper'

class TestMt940Rabobank < Test::Unit::TestCase

  context 'Before SEPA' do
    setup do
      file_name = File.dirname(__FILE__) + '/fixtures/rabobank.txt'
      @transactions = MT940::Parser.new(file_name).transactions
    end

    should 'have the correct number of transactions' do
      assert_equal 3, @transactions.size
    end

    context 'Transaction' do

      setup do
        @transaction = @transactions.first
      end

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

  end

  context 'After SEPA' do
    setup do
      file_name = File.dirname(__FILE__) + '/fixtures/rabobank_sepa.txt'
      @transactions = MT940::Parser.new(file_name).transactions
    end

    should 'have the correct number of transactions' do
      assert_equal 12, @transactions.size
    end

    context 'Transaction' do

      setup do
        @transaction = @transactions.first
      end

      should 'have a bank_account' do
        assert_equal 'NL50RABO0123456789', @transaction.bank_account
      end

      context 'Contra account' do
        should 'be determined in case of a GIRO account' do
          assert_equal 'NL96RBOS0523149468', @transaction.contra_account
        end

        should 'be determined in case of a regular bank' do
          assert_equal '0663616476', @transactions[1].contra_account
        end

        should 'be determined in case of Postbank account' do
          assert_equal 'P004500018', @transactions[4].contra_account
        end
      end

      should 'have an amount' do
        assert_equal -127.50, @transaction.amount
      end

      should 'have a currency' do
        assert_equal 'EUR', @transaction.currency
      end

      should 'not be able to determine a contra_account_owner' do
        assert !@transaction.contra_account_owner
      end

      should 'have a description' do
        assert_equal 'DIVV afd parkeergebouwewn Factuur 307472', @transactions[4].description
      end

      should 'have a date' do
        assert_equal Date.new(2013,4,3), @transaction.date
      end

      should 'return its bank' do
        assert_equal 'Rabobank', @transaction.bank
      end

    end

  end

end
