class MT940::Abnamro < MT940::Base

  def parse
    tag86 = false
    @lines.each do |line|
      if line.match(/^:25:(\d*)/) 
        @bank_account = $1
        tag86 = false
      elsif line.match(/^:61:\d{6}\d{4}(C|D)(\d+),(\d{0,2})/) #:61:1105240524D9,N192NONREF
        type = $1 == 'D' ? -1 : 1
        @transaction = MT940::Transaction.new(:bank_account => @bank_account, :amount => type * ($2 + '.' + $3).to_f)
        @transactions << @transaction
        tag86 = false
      elsif line.match(/^:86:(.*)$/)
        @transaction.description = $1.strip
        tag86 = true
      elsif tag86 && line.match(/^[^:]/)
        @transaction.description += ' ' + line.strip.gsub(/\n/,'')
      end
    end
  end

end
