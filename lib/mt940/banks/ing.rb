class MT940::Ing < MT940::Base

  private

  def parse_line_before_sepa
    pattern = Regexp.new "(#{MT940::BBAN_PATTERN}|#{MT940::IBAN_PATTERN}|\s)(.+)"
    if @line.match(pattern)
      @description    = $2.strip
      @contra_account = $1 #[/[^0+]\d*/]
    end
  end

  def parse_line_after_sepa
    pattern = Regexp.new "(#{MT940::SEPA_PATTERN})(.+)"
    if @line.match(pattern)
      @description    = $2.strip
      @contra_account = $1
    end
  end

  def parse_tag_86
    if @line.match(/^:86:(.*)$/)
      @line = $1.strip
      sepa? ? parse_line_after_sepa : parse_line_before_sepa
      @transaction.contra_account = @contra_account
      @transaction.description    = @description
    end
  end
  
  def sepa?
    @line.match(MT940::SEPA_PATTERN)
  end

end