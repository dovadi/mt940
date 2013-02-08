class MT940::Abnamro < MT940::Base

  def self.determine_bank(*args)
    self if args[0].match(/ABNANL/)
  end

  def parse_tag_61
    super(/^:61:(\d{6})\d{4}(C|D)(\d+),(\d{0,2})/)
  end

  def parse_contra_account
    if @transaction
      if @transaction.description.match(/^(GIRO)\s+(\d+)(.+)/)
        @transaction.contra_account = $2.rjust(9, '000000000')
        @transaction.description    = $3
      elsif @transaction.description.match(/^(\d{2}.\d{2}.\d{2}.\d{3})(.+)/)
        @transaction.description    = $2
        @transaction.contra_account = $1.gsub('.','')
      end
    end
  end

end
