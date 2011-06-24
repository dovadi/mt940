class MT940::Abnamro < MT940::Base

  def parse_tag_61
    if @line.match(/^:61:\d{6}\d{4}(C|D)(\d+),(\d{0,2})/)
      type = $1 == 'D' ? -1 : 1
      @transaction = MT940::Transaction.new(:bank_account => @bank_account, :amount => type * ($2 + '.' + $3).to_f)
      @transactions << @transaction
      @tag86 = false
    end
  end

end
