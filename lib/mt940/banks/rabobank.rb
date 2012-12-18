class MT940::Rabobank < MT940::Base

  def self.determine_bank(*args)
    self if args[0].match(/^:940:/)
  end

  def parse_tag_61
    if @line.match(/^:61:(\d{6})(C|D)(\d+),(\d{0,2})\w{4}\w{1}(\d{9}|NONREF)(.+)$/)
      type = $2 == 'D' ? -1 : 1
      @transaction = MT940::Transaction.new(:bank_account => @bank_account, :amount => type * BigDecimal.new($3 + '.' + $4), :bank => @bank, :currency => @currency)
      @transaction.date = parse_date($1)
      @transaction.contra_account = $5.strip
      @transaction.contra_account_owner = $6.strip
      @statement_transactions << @transaction
      @transactions << @transaction
    end
  end

end
