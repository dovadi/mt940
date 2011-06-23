class MT940::ING < MT940::Base

  def parse
    @lines.each do |line|
      if line.match(/^:25:(\d{10})/)
        @bank_account = $1
      elsif line.match(/^:61:(\d{6})(C|D)(\d+),(\d{2})/)
        type = $2 == 'C' ? -1 : 1
        @transaction = MT940::Transaction.new(:bank_account => @bank_account, :amount => type * ($3 + $4).to_f / 100)
        @transactions << @transaction
      elsif line.match(/^:86:(\d{3,10})\s?(.*)$/)
        @transaction.contra_account = $1
        @transaction.description    = $2
      end
    end
  end

end