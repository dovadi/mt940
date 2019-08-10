module MT940
  class Ing < Base
    private

    def parse_line_before_sepa
      pattern = Regexp.new "(#{BBAN_PATTERN})(.+)"
      return unless @line.match(pattern)

      @description    = Regexp.last_match(2).strip
      @contra_account = Regexp.last_match(1)[/[^0+]\d*/]
    end

    def parse_line_after_sepa
      return unless @line.match(SEPA_PATTERN)

      @contra_account = Regexp.last_match(1)
      @description    = Regexp.last_match(4).strip
    end

    def sepa?
      @line.match(SEPA_PATTERN)
    end
  end
end
