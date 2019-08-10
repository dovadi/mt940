module MT940
  class Rabobank < Base
    def initialize(file)
      @sepa = false
      @description = nil
      super(file)
    end

    private

    def parse_tag_25
      @line.gsub!('.', '')
      if @line.match(Regexp.new(":25:(#{IBAN_PATTERN})"))
        @bank_account = Regexp.last_match(1)
        @sepa = true
      elsif @line.match(/^:\d{2}:[^\d]*(\d*)/)
        @bank_account = Regexp.last_match(1).gsub(/^0/, '')
      end
    end

    def parse_tag_61
      match = super(/^:61:(\d{6})(C|D)(\d+),(\d{0,2})\w{4}\w{1}(\d{9}|NONREF|EREF)(.*)$/)
      return unless match

      if @sepa
        @transaction.contra_account = match[6].strip
      else
        @transaction.contra_account = match[5].strip
        @transaction.contra_account_owner = match[6].strip
      end
    end

    def parse_tag_86
      return unless @line.match(/^:86:(.*)$/)

      @line = Regexp.last_match(1).strip
      @sepa ? determine_description_after_sepa : determine_description_before_sepa
      @transaction.description = @description.strip
    end

    def determine_description_before_sepa
      if @description.nil?
        @description = @line
      else
        @description += ' ' + @line
      end
    end

    def determine_description_after_sepa
      hash = hashify_description(@line)
      @description = ''
      @description += hash['NAME'] if hash['NAME']
      @description += ' '
      @description += hash['REMI'] if hash['REMI']
    end
  end
end
