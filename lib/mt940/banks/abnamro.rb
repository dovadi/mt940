module MT940
  class Abnamro < Base
    private

    def parse_tag_61
      super(/^:61:(\d{6})\d{4}(C|D)(\d+),(\d{0,2})/)
    end

    def parse_line_before_sepa
      @description = @line.gsub(/>\d{2}/, '').strip
      if @description.match(/^(GIRO)\s+(\d+)(.+)/)
        @contra_account = Regexp.last_match(2).rjust(9, '000000000')
        @description    = Regexp.last_match(3)
      elsif @description.match(/^(\d{2}.\d{2}.\d{2}.\d{3})(.+)/)
        @description    = Regexp.last_match(2)
        @contra_account = Regexp.last_match(1).gsub('.', '')
      end
    end

    def parse_line_after_sepa
      hash = hashify_description(@line)
      @description = hash['REMI']
      @contra_account = hash['IBAN']
    end

    def sepa?
      @line[0] == '/'
    end
  end
end
