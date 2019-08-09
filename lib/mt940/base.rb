module MT940

  BBAN_PATTERN     = '^\d{10}'
  IBAN_PATTERN     = '[a-zA-Z]{2}[0-9]{2}[a-zA-Z0-9]{4}[0-9]{7}([a-zA-Z0-9]?){0,16}'
  BIC_CODE_PATTERN = MT940::BIC_CODES.values.join('|')
  SEPA_PATTERN     = Regexp.new "(#{IBAN_PATTERN})\\s+(#{BIC_CODE_PATTERN})(.+)$"

  class Base

    attr_accessor :bank, :transactions

    def initialize(file)
      @transactions, @lines = [], []
      @bank = self.class.to_s.split('::').last
      file.readlines.each do |line|
        line.encode!('UTF-8', 'UTF-8', :invalid => :replace)
        begin_of_line?(line) ? @lines << line : @lines[-1] += line
      end
    end

    def parse
      @lines.each do |line|
        @line = line.strip.gsub(/\n|\r/,'').gsub(/\s{2,}/,' ')
        parse_tag($1) if @line.match(/^:(\d{2}F?):/)
      end
    end

    private

    def parse_tag(tag)
      case tag
      when '25'
        parse_tag_25
      when '60F'
        parse_tag_60F
      when '61'
        parse_tag_61
        @transactions << @transaction if @transaction
      when '86'
        parse_tag_86 if @transaction
      when '62F'
        @transaction = nil #Ignore 'eindsaldo'
      end
    end

    def begin_of_line?(line)
      line.match(/^:|^940|^0000\s|^ABNA/)
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
      match = @line.match(pattern)
      if match
        @transaction = create_transaction(match)
        @transaction.date = parse_date(match[1])
      end
      match
    end

    def parse_tag_86
      if @line.match(/^:86:\s?(.*)$/)
        @line = $1.strip
        @description, @contra_account = nil, nil
        sepa? ? parse_line_after_sepa : parse_line_before_sepa
        @transaction.contra_account = @contra_account
        @transaction.description    = @description || @line
      end
    end

    def hashify_description(description)
      hash = {}
      description.gsub!(/[^A-Z]\/[^A-Z]/,' ') #Remove single forward slashes '/', which are not part of a swift code
      description[1..-1].split('/').each_slice(2).each do |first, second|
        hash[first] = second
      end
      hash
    end

    def create_transaction(match)
      type = match[2] == 'D' ? -1 : 1
      MT940::Transaction.new(:bank_account => @bank_account,
                             :amount       => type * (match[3] + '.' + match[4]).to_f,
                             :bank         => @bank,
                             :currency     => @currency)
    end

    def parse_date(string)
      Date.new(2000 + string[0..1].to_i, string[2..3].to_i, string[4..5].to_i) if string
    end

  end

end
