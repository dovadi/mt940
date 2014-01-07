class MT940::Triodos < MT940::Base

  def parse_contra_account
    if @transaction && @transaction.description.match(/\d+(\d{9})$/)
      @transaction.contra_account = $1.rjust(9, '000000000')
      @transaction.description = ''
    end
  end

end
