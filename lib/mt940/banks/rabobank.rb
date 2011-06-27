class MT940::Rabobank < MT940::Base

  def parse_tag_61
    if @line.match(/^:61:(\d{6})(C|D)(\d+),(\d{0,2})\w{4}(.{16})(.+)$/)
      type = $2 == 'D' ? -1 : 1
      @transaction = MT940::Transaction.new(:bank_account => @bank_account, :amount => type * ($3 + '.' + $4).to_f)
      @transaction.date = parse_date($1)
      @transaction.contra_account = $5.strip
      @transaction.contra_account_owner = $6.strip
      @transactions << @transaction
    end
  end

  def parse_tag_86
    @transaction.description = $1.strip if @line.match(/^:86:(.*)$/)
  end

end
