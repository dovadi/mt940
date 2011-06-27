class MT940::Abnamro < MT940::Base

  def parse_tag_61
    if @line.match(/^:61:(\d{6})\d{4}(C|D)(\d+),(\d{0,2})/)
      type = $2 == 'D' ? -1 : 1
      @transaction = MT940::Transaction.new(:bank_account => @bank_account, :amount => type * ($3 + '.' + $4).to_f)
      @transaction.date = parse_date($1)
      @transactions << @transaction
      @tag86 = false
    end
  end

end
