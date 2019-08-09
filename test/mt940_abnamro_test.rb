require 'test_helper'

class TestMt940Abnamro < Test::Unit::TestCase

  context 'Before SEPA' do

    setup do
      file_name = File.dirname(__FILE__) + '/fixtures/abnamro.txt'
      @transactions = MT940::Parser.new(file_name).transactions
    end
    
    should 'have the correct number of transactions' do
      assert_equal 10, @transactions.size
    end

    context 'Transaction' do

      setup do 
        @transaction = @transactions.first
      end

      should 'have a bank_account' do
        assert_equal '517852257', @transaction.bank_account
      end

      should 'have an amount' do
        assert_equal(-9.00, @transaction.amount)
      end

      context 'Description' do
        should 'have the correct description in case of a GIRO account' do
          assert_equal ' KPN - DIGITENNE BETALINGSKENM. 0000000421886595314606715 BETREFT FACTUUR D.D. 20-05-2011INCL. 1,44 BTW', @transaction.description
        end

        should 'have the correct description in case of a regular bank' do
          assert_equal ' MYCOM DEN HAAG S-GRAVEN,PAS999', @transactions.last.description
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

  context 'After SEPA' do

    setup do
      file_name = File.dirname(__FILE__) + '/fixtures/abnamro_sepa.txt'
      @transactions = MT940::Parser.new(file_name).transactions
    end
    
    should 'have the correct number of transactions' do
      assert_equal 1, @transactions.size
    end

    context 'Transaction' do

      setup do 
        @transaction = @transactions.first
      end

      should 'have a bank_account' do
        assert_equal '123456789', @transaction.bank_account
      end

      should 'have a date' do
        assert_equal Date.new(2012,9,27), @transaction.date
      end

      should 'have an amount' do
        assert_equal 0.01, @transaction.amount
      end

      should 'return its bank' do
        assert_equal 'Abnamro', @transaction.bank
      end

      should 'have a currency' do
        assert_equal 'EUR', @transaction.currency
      end

      should 'be determined in case of a GIRO account' do
        assert_equal 'NL73ANDL0123456789', @transaction.contra_account
      end

      should 'have the correct description in case of a regular bank' do
        assert_equal 'Dit zijn de omschrijvingsregels', @transactions.last.description
      end

    end

  end


end
