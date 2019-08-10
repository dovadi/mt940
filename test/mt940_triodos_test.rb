require 'test_helper'

class TestMt940Triodos < Test::Unit::TestCase
  context 'Before sepa' do
    setup do
      file_name = File.dirname(__FILE__) + '/fixtures/triodos.txt'
      @transactions = MT940::Parser.new(file_name).transactions
    end

    should 'have the correct number of transactions' do
      assert_equal 2, @transactions.size
    end

    context 'Transaction' do
      setup do
        @transaction = @transactions.first
      end

      should 'have a bank_account' do
        assert_equal '390123456', @transaction.bank_account
      end

      should 'have an amount' do
        assert_equal(-15.7, @transaction.amount)
      end

      should 'have a currency' do
        assert_equal 'EUR', @transaction.currency
      end

      should 'have a description' do
        assert_equal(
          'ALGEMENE TUSSENREKENING KOSTEN VAN 01-10-2010 TOT EN MET 31-12-2010',
          @transaction.description
        )
      end

      should 'have a date' do
        assert_equal Date.new(2011, 1, 1), @transaction.date
      end

      should 'return its bank' do
        assert_equal 'Triodos', @transaction.bank
      end

      should 'return the contra_account' do
        assert_equal '987654321', @transaction.contra_account
      end
    end
  end

  context 'After sepa' do
    setup do
      file_name = File.dirname(__FILE__) + '/fixtures/triodos_sepa.txt'
      @transactions = MT940::Parser.new(file_name).transactions
    end

    should 'have the correct number of transactions' do
      assert_equal 8, @transactions.size
    end

    context 'Transaction' do
      setup do
        @transaction = @transactions.first
      end

      should 'have a bank_account' do
        assert_equal '666666666', @transaction.bank_account
      end

      should 'have an amount' do
        assert_equal(-10.00, @transaction.amount)
      end

      should 'have a currency' do
        assert_equal 'EUR', @transaction.currency
      end

      context 'description' do
        setup do
          @description =
            'TENAAMSTELLING TEGENREKENING EN ADRES TEGENREKENING EN  '\
            'PLAATS TEGENREKENING EN EEN LANGE OMSCHRIJVING VAN DE  TRANSACTIE'
        end

        should 'have the description in case of BBAN' do
          assert_equal @description, @transaction.description
        end

        should 'have the description in case of IBAN' do
          assert_equal @description, @transactions[2].description
        end
      end

      should 'have a date' do
        assert_equal Date.new(2012, 11, 23), @transaction.date
      end

      should 'return its bank' do
        assert_equal 'Triodos', @transaction.bank
      end

      context 'contra_account' do
        should 'return the contra_account in case of a BBAN' do
          assert_equal '555555555', @transaction.contra_account
        end

        should 'return the contra_account in case of a IBAN' do
          assert_equal 'AA99BBBB0555555555', @transactions[2].contra_account
        end
      end
    end
  end
end
