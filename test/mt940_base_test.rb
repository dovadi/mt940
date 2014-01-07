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

end
