class MT940::Abnamro < MT940::Base

  private

  def parse_tag_61
    super(/^:61:(\d{6})\d{4}(C|D)(\d+),(\d{0,2})/)
  end

  def parse_tag_86
    if @line.match(/^:86:\s?(.*)$/)
      @tag86 = true
      @description = $1.gsub(/>\d{2}/,'').strip
      parse_description
    end
  end

  def parse_description
    if @description[0] == "/"
    else
      determine_contra_account
    end
    @transaction.description = @description
  end

  def determine_contra_account
    if @transaction
      if @description.match(/^(GIRO)\s+(\d+)(.+)/)
        @transaction.contra_account = $2.rjust(9, '000000000')
        @description    = $3
      elsif @description.match(/^(\d{2}.\d{2}.\d{2}.\d{3})(.+)/)
        @description    = $2
        @transaction.contra_account = $1.gsub('.','')
      end
    end
  end

end
