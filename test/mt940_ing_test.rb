require 'test_helper'

class TestMt940Ing < Test::Unit::TestCase

  context 'Before SEPA' do
    setup do
      file_name = File.dirname(__FILE__) + '/fixtures/ing.txt'
      @transactions = MT940::Parser.new(file_name).transactions
    end
    
    should 'have the correct number of transactions' do
      assert_equal 6, @transactions.size
    end

    context 'Transaction' do

      setup do
        @transaction = @transactions.first
      end

      should 'have a bank_account' do
        assert_equal '001234567', @transaction.bank_account
      end

      should 'have an amount' do
        assert_equal(-25.03, @transaction.amount)
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
  end

  context 'After SEPA' do
    setup do
      # Fixture contains a mixture of transactions with and without iban numbers
      file_name = File.dirname(__FILE__) + '/fixtures/ing_sepa.txt'
      @transactions = MT940::Parser.new(file_name).transactions
    end
    
    should 'have the correct number of transactions' do
      assert_equal 9, @transactions.size
    end

    context 'Transaction' do

      setup do
        @transaction = @transactions.first
      end

      should 'have a bank_account' do
        assert_equal '654321789', @transaction.bank_account
      end

      should 'have an amount' do
        assert_equal 1.41, @transaction.amount
      end

      should 'have a currency' do
        assert_equal 'EUR', @transaction.currency
      end

      should 'have a date' do
        assert_equal Date.new(2012,8,10), @transaction.date
      end

      should 'return its bank' do
        assert_equal 'Ing', @transaction.bank
      end

      context 'With an iban number in :86' do
        should 'have a description' do
          assert_equal 'J. Janssen 20120123456789 Factuurnr 123456 Klantnr 00123', @transactions[1].description
        end

        should 'return the contra_account' do
          assert_equal 'NL69INGB0123456789', @transactions[1].contra_account
        end
      end

      context 'Without an iban number in :86' do
        should 'have a description' do
          assert_equal 'Reguliere aflossingStarters Investeri 11.22.33.444 Rest hoofdsom EUR 99.000,00', @transactions[8].description
        end

        should 'return the contra_account' do
          assert_equal nil, @transactions[8].contra_account
        end
      end

    end
  end

end
