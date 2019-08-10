module MT940
  BBAN_PATTERN     = '^\d{10}'.freeze
  IBAN_PATTERN     = '[a-zA-Z]{2}[0-9]{2}[a-zA-Z0-9]{4}[0-9]{7}([a-zA-Z0-9]?){0,16}'.freeze
  BIC_CODE_PATTERN = MT940::BIC_CODES.values.join('|')
  SEPA_PATTERN     = Regexp.new "(#{IBAN_PATTERN})\\s+(#{BIC_CODE_PATTERN})(.+)$"

  class Base
    attr_accessor :bank, :transactions

    def initialize(file)
      @transactions = []
      @lines = []
      @bank = self.class.to_s.split('::').last
      file.readlines.each do |line|
        line.encode!('UTF-8', 'UTF-8', invalid: :replace)
        begin_of_line?(line) ? @lines << line : @lines[-1] += line
      end
    end

    def parse
      @lines.each do |line|
        @line = line.strip.gsub(/\n|\r/, '').gsub(/\s{2,}/, ' ')
        parse_tag(Regexp.last_match(1)) if @line.match(/^:(\d{2}F?):/)
      end
    end

    private

    # rubocop:disable Metrics/MethodLength
    def parse_tag(tag)
      case tag
      when '25'
        parse_tag_25
      when '60F'
        parse_tag_60_f
      when '61'
        parse_tag_61
      when '86'
        parse_tag_86
      when '62F'
        parse_tag_62_f
      end
    end
    # rubocop:enable Metrics/MethodLength

    def begin_of_line?(line)
      line.match(/^:|^940|^0000\s|^ABNA/)
    end

    def parse_tag_25
      @line.gsub!('.', '')
      @bank_account = Regexp.last_match(1).gsub(/^0/, '') if @line.match(/^:\d{2}:[^\d]*(\d*)/)
    end

    def parse_tag_60_f
      @currency = @line[12..14]
    end

    def parse_tag_61(pattern = nil)
      pattern ||= /^:61:(\d{6})(C|D)(\d+),(\d{0,2})/
      match = @line.match(pattern)
      if match
        @transaction = create_transaction(match)
        @transaction.date = parse_date(match[1])
      end
      @transactions << @transaction if @transaction
      match
    end

    def parse_tag_86
      return unless @transaction

      return unless @line.match(/^:86:\s?(.*)$/)

      @line = Regexp.last_match(1).strip
      @description = nil
      @contra_account = nil
      sepa? ? parse_line_after_sepa : parse_line_before_sepa
      @transaction.contra_account = @contra_account
      @transaction.description    = @description || @line
    end

    def parse_tag_62_f
      @transaction = nil
    end

    def hashify_description(description)
      hash = {}
      description.gsub!(%r{[^A-Z]/[^A-Z]}, ' ') # Remove single forward slashes '/', which are not part of a swift code
      description[1..-1].split('/').each_slice(2).each do |first, second|
        hash[first] = second
      end
      hash
    end

    def create_transaction(match)
      type = match[2] == 'D' ? -1 : 1
      MT940::Transaction.new(bank_account: @bank_account,
                             amount: type * (match[3] + '.' + match[4]).to_f,
                             bank: @bank,
                             currency: @currency)
    end

    def parse_date(string)
      Date.new(2000 + string[0..1].to_i, string[2..3].to_i, string[4..5].to_i) if string
    end
  end
end
