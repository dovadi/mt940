module MT940

  class Transaction

    attr_accessor :bank_account, :contra_account, :amount, :description, :contra_account_owner, :date

    def initialize(attributes = {})
      @bank_account        = attributes[:bank_account]
      @amount              = attributes[:amount]
      @description         = attributes[:description]
      @date                = attributes[:date]
      @contra_account      = attributes[:contra_account]
      @contra_account_name = attributes[:contra_account_owner]
    end

  end

end