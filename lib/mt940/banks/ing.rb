class MT940::Ing < MT940::Base

  private

  def parse_line_before_sepa
    pattern = Regexp.new "(#{MT940::BBAN_PATTERN})(.+)"
    if @line.match(pattern)
      @description    = $2.strip
      @contra_account = $1[/[^0+]\d*/]
    end
  end

  def parse_line_after_sepa
    if @line.match(MT940::SEPA_PATTERN)
      @contra_account = $1
      @description    = $4.strip
    end
  end

  def sepa?
    @line.match(MT940::SEPA_PATTERN)
  end

end