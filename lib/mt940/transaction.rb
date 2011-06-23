module MT940
  
  class Transaction

    attr_accessor :bank_account, :contra_account, :amount, :description

    def initialize(attributes = {})
      @bank_account = attributes[:bank_account]
      @amount       = attributes[:amount]
      @description  = attributes[:description]
    end

  end

end