class MT940::Ing < MT940::Base

  def parse_contra_account
    if @transaction && @transaction.description.match(/^\d(\d{9})(.+)/)
       @transaction.contra_account = $1
       @transaction.description = $2
     end
  end

end