module MT940
  
  class Transaction

    attr_accessor :bank_account, :contra_account, :amount, :description

    def initialize(fields = {})
      @bank_account = fields[:bank_account]
      @amount       = fields[:amount]
      @description  = fields[:description]
    end

  end

end