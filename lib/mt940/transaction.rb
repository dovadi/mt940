module MT940

  class Transaction

    attr_accessor :bank_account, :contra_account, :amount, :description, :contra_account_owner, :date, :bank, :currency

    def initialize(attributes = {})
      @bank_account        = attributes[:bank_account]
      @bank                = attributes[:bank]
      @amount              = attributes[:amount]
      @description         = attributes[:description]
      @date                = attributes[:date]
      @contra_account      = attributes[:contra_account]
      @contra_account_name = attributes[:contra_account_owner]
      @currency            = attributes[:currency]
    end

  end

end