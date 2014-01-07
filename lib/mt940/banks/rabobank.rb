class MT940::Rabobank < MT940::Base

  private

  def parse_tag_61
    if @line.match(/^:61:(\d{6})(C|D)(\d+),(\d{0,2})\w{4}\w{1}(\d{9}|NONREF)(.+)$/)
      type = $2 == 'D' ? -1 : 1
      @transaction = MT940::Transaction.new(:bank_account => @bank_account, :amount => type * ($3 + '.' + $4).to_f, :bank => @bank, :currency => @currency)
      @transaction.date = parse_date($1)
      @transaction.contra_account = $5.strip
      @transaction.contra_account_owner = $6.strip
      @transactions << @transaction
    end
  end

  def parse_tag_86
    if @line.match(/^:86:(.*)$/)
      if @transaction.description.nil? 
        @transaction.description= $1.strip 
      else
        @transaction.description += ' ' +$1.strip 
      end
    end
  end

end
