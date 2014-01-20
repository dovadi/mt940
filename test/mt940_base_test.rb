require 'helper'

class TestMt940Base < Test::Unit::TestCase

  context 'MT940::Base' do
    should 'read the transactions with the handle to the mt940 file itself' do
      file_name = File.dirname(__FILE__) + '/fixtures/ing.txt'
      assert_equal 6, MT940::Parser.new(file_name).transactions.size
    end

    #Tempfile is used by Paperclip, so the following will work:
    #MT940::Base.transactions(@mt940_file.attachment.to_file)
    should 'read the transactions with the handle of a Tempfile' do
      file = Tempfile.new('temp')
      file.write(':940:')
      file.rewind
      assert_equal 0, MT940::Parser.new(file).transactions.size
      file.unlink
    end

    should 'raise an exception if the file does not exist' do
      file_name = File.dirname(__FILE__) + '/fixtures/123.txt'
      assert_raise Errno::ENOENT do
        file = MT940::Parser.new(file_name)
      end
    end

    should 'raise an NoFileGiven if a wrong argument was given' do
      assert_raise MT940::NoFileGiven do
        MT940::Parser.new(Hash.new)
      end
    end
  end

  context 'Unknown MT940 file' do
    should 'raise an UnknownBank if bank could not be determined' do
      file_name = File.dirname(__FILE__) + '/fixtures/unknown.txt'
      assert_raise MT940::UnknownBank do
        MT940::Parser.new(file_name)
      end
    end
  end
  
  
  context 'MT940::Account' do

    setup do
      # Fixture contains a mixture of transactions with and without iban numbers
      file_name = File.dirname(__FILE__) + '/fixtures/ing_sepa.txt'
      @parser = MT940::Parser.new(file_name)
      @transactions = @parser.transactions
    end

    should 'have the correct accountnumber' do
      assert_equal "654321789", @parser.account.number
    end

    should 'have the correct currency' do
      assert_equal "EUR", @parser.account.currency
    end

    should 'have the correct opening balance' do
      assert_equal "2012-08-10", @parser.account.opening_balance.date.to_s
      assert_equal 68.20 , @parser.account.opening_balance.amount
    end
 
    should 'have the correct closing balance' do
      assert_equal "2012-08-11", @parser.account.closing_balance.date.to_s
      assert_equal 1005.83 , @parser.account.closing_balance.amount
    end

    # the difference between the opening and closing balance should equal the net change of transactions
    should 'calculate the correct difference between the opening and closing balance' do
      assert_equal @transactions.map(&:amount).reduce(:+), @parser.account.closing_balance.amount - @parser.account.opening_balance.amount
    end
    
  end

end
