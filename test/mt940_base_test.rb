require 'helper'

class TestMt940Base < Test::Unit::TestCase

  context 'MT940::Base' do
    should 'read the transactions with the filename of the MT940 file' do
      file_name = File.dirname(__FILE__) + '/fixtures/ing.txt'
      @transactions = MT940::Base.transactions(file_name)
      assert_equal 6, @transactions.size
    end

    should 'read the transactions with the handle to the mt940 file itself' do
      file_name = File.dirname(__FILE__) + '/fixtures/ing.txt'
      file = File.open(file_name, 'r:utf-8')
      @transactions = MT940::Base.transactions(file)
      assert_equal 6, @transactions.size
    end

    #Tempfile is used by Paperclip, so the following will work:
    #MT940::Base.transactions(@mt940_file.attachment.to_file)
    should 'read the transactions with the handle of a Tempfile' do
      file = Tempfile.new('temp')
      file.write(':940:')
      file.rewind
      @transactions = MT940::Base.transactions(file)
      assert_equal 0, @transactions.size
      file.unlink
    end

    should 'raise an exception if the file does not exist' do
      file_name = File.dirname(__FILE__) + '/fixtures/123.txt'
      assert_raise Errno::ENOENT do
        @transactions = MT940::Base.transactions(file_name)
      end
    end

    should 'raise an ArgumentError if a wrong argument was given' do
      assert_raise ArgumentError do
        MT940::Base.transactions(Hash.new)
      end
    end
  end

  context 'Unknown MT940 file' do
    should 'return its bank' do
      file_name = File.dirname(__FILE__) + '/fixtures/unknown.txt'
      @transactions = MT940::Base.transactions(file_name)
      assert_equal 'Unknown', @transactions.first.bank
    end
  end

end
