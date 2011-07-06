class MT940::Abnamro < MT940::Base

  def self.determine_bank(*args)
    self if args[0].match(/ABNANL/)
  end

  def parse_tag_61
    if @line.match(/^:61:(\d{6})\d{4}(C|D)(\d+),(\d{0,2})/)
      type = $2 == 'D' ? -1 : 1
      @transaction = MT940::Transaction.new(:bank_account => @bank_account, :amount => type * ($3 + '.' + $4).to_f, :bank => @bank)
      @transaction.date = parse_date($1)
      @transactions << @transaction
      @tag86 = false
    end
  end

  def parse_contra_account
    if @transaction
      if @transaction.description.match(/^(GIRO)\s+(\d+)(.+)/)
        @transaction.contra_account = 'P' + $2.rjust(9, '000000000')
        @transaction.description = $3
      elsif @transaction.description.match(/^(\d{2}.\d{2}.\d{2}.\d{3})(.+)/)
        @transaction.contra_account = $1
        @transaction.description = $2
      end
    end
  end

end
