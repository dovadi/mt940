class MT940::ING < MT940::Base

  def parse
    tag86 = false
    @lines.each do |line|
      if line.match(/^:25:(\d{10})/)
        @bank_account = $1
        tag86 = false
      elsif line.match(/^:61:(\d{6})(C|D)(\d+),(\d{0,2})/)
        type = $2 == 'D' ? -1 : 1
        @transaction = MT940::Transaction.new(:bank_account => @bank_account, :amount => type * ($3 + '.' + $4).to_f)
        @transactions << @transaction
        tag86 = false
      elsif line.match(/^:86:\s?(.*)$/)
        tag86 = true
        @transaction.description = $1
      elsif tag86 && line.match(/^[^:]/)
        @transaction.description += ' ' + line.strip.gsub(/\n/,'')
      end
    end
  end

end