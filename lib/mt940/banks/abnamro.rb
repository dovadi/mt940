class MT940::Abnamro < MT940::Base

  private

  def parse_tag_61
    super(/^:61:(\d{6})\d{4}(C|D)(\d+),(\d{0,2})/)
  end

  def parse_tag_86
    if @line.match(/^:86:\s?(.*)$/)
      @line = $1
      sepa? ? parse_line_after_sepa : parse_line_pre_sepa
      @transaction.contra_account = @contra_account
      @transaction.description    = @description
    end
  end

  def parse_line_pre_sepa
    @description = @line.gsub(/>\d{2}/,'').strip
    if @description.match(/^(GIRO)\s+(\d+)(.+)/)
      @contra_account = $2.rjust(9, '000000000')
      @description    = $3
    elsif @description.match(/^(\d{2}.\d{2}.\d{2}.\d{3})(.+)/)
      @description    = $2
      @contra_account = $1.gsub('.','')
    end
  end

  def parse_line_after_sepa
    hash = hashify_line
    @description    = hash['REMI']
    @contra_account = hash['IBAN']
  end

  def hashify_line
    hash = {} 
    @line.gsub!(/[^A-Z]\/[^A-Z]/,' ') #Remove single forward slashes '/', which are not part of a swift code
    @line[1..-1].split('/').each_slice(2).each do |first, second|
      hash[first] = second
    end
    hash
  end

  def sepa?
    @line[0] == '/'
  end

end

