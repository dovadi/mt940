class MT940::Rabobank < MT940::Base

  def parse
    @lines.each do |line|
      if line.match(/^:25:(\d{4}.\d{2}.\d{3})/)
        @bank_account = $1
      elsif line.match(/^:61:\d{6}(C|D)(\d+),(\d{2})\w{4}(.{16})(.+)$/)
        type = $1 == 'D' ? -1 : 1
        @transaction = MT940::Transaction.new(:bank_account => @bank_account, :amount => type * ($2 + '.' + $3).to_f)
        @transaction.contra_account = $4.strip
        @transaction.contra_account_name = $5.strip
        @transactions << @transaction
      elsif line.match(/^:86:(.*)$/)
        @transaction.description = $1.strip
      end
    end
  end

end