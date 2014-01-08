module MT940

  BBAN_PATTERN     = '^\d{10}'
  IBAN_PATTERN     = 'NL\d{2}[A-Z]{4}\d{10}'
  BIC_CODE_PATTERN = MT940::BIC_CODES.values.join('|')
  SEPA_PATTERN     = Regexp.new "(#{BBAN_PATTERN})\\s+(#{IBAN_PATTERN})\\s+(#{BIC_CODE_PATTERN})(.+)$"

  class Base

    attr_accessor :bank, :transactions

    def initialize(file)
      @transactions, @lines = [], []
      @bank  = self.class.to_s.split('::').last
      file.readlines.each do |line|
        begin_of_line?(line) ? @lines << line : @lines[-1] += line
      end
    end

    def parse
      @lines.each do |line|
        @line = line.strip.gsub(/\n/,'')
        if @line.match(/^:(\d{2}F?):/)
          case $1
          when '25'
            parse_tag_25
          when '60F'
            parse_tag_60F
          when '61'
            parse_tag_61
          when '86'
            parse_tag_86 if @transaction
          when '62F'
            @transaction = nil #Ignore 'eindsaldo'
          end
        end
      end
    end

    private

    def begin_of_line?(line)
      line.match /^:|^940|^0000\s|^ABNA/
    end

    def parse_tag_25
      @line.gsub!('.','')
      @bank_account = $1.gsub(/^0/,'') if @line.match(/^:\d{2}:[^\d]*(\d*)/)
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
      end
    end

    def parse_tag_86
      if @line.match(/^:86:\s?(.*)$/)
        @line = $1.strip
        sepa? ? parse_line_after_sepa : parse_line_before_sepa
        @transaction.contra_account = @contra_account
        @transaction.description    = @description
      end
    end

    def parse_date(string)
      Date.new(2000 + string[0..1].to_i, string[2..3].to_i, string[4..5].to_i) if string
    end

  end

end
