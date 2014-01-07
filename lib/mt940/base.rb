module MT940

  class Base

    attr_accessor :bank, :transactions

    def initialize(file)
      @transactions = []
      @bank  = self.class.to_s.split('::').last
      @lines = file.readlines
    end

    def parse
      @tag86 = false
      @lines.each do |line|
        @line = line
        @line.match(/^:(\d{2}F?):/) ? eval('parse_tag_'+ $1) : parse_line
      end
    end

    private

    def parse_tag_25
      @line.gsub!('.','')
      if @line.match(/^:\d{2}:[^\d]*(\d*)/)
        @bank_account = $1.gsub(/^0/,'')
        @tag86 = false
      end
    end

    def parse_tag_60F
      @currency = @line[12..14]
    end

    def parse_tag_61(pattern = nil)
      pattern = pattern || /^:61:(\d{6})(C|D)(\d+),(\d{0,2})/
      if @line.match(pattern)
        type = $2 == 'D' ? -1 : 1
        @transaction = MT940::Transaction.new(:bank_account => @bank_account, :amount => type * ($3 + '.' + $4).to_f, :bank => @bank, :currency => @currency)
        @transaction.date = parse_date($1)
        @transactions << @transaction
        @tag86 = false
      end
    end

    def parse_tag_86
      if !@tag86 && @line.match(/^:86:\s?(.*)$/)
        @tag86 = true
        @transaction.description = $1.gsub(/>\d{2}/,'').strip
        parse_contra_account
      end
    end

    def parse_line
      if @tag86 && @transaction.description
        @transaction.description.lstrip!
        @transaction.description += ' ' + @line.gsub(/\n/,'').gsub(/>\d{2}\s*/,'').gsub(/\-XXX/,'').gsub(/-$/,'').strip
        @transaction.description.strip!
      end
    end

    def parse_date(string)
      Date.new(2000 + string[0..1].to_i, string[2..3].to_i, string[4..5].to_i) if string
    end

    #Fail silently
    def method_missing(*args)
    end

  end

end
