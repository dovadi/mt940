module MT940

  class Transaction

    attr_accessor :bank_account, :contra_account, :amount, :description, :contra_account_name

    def initialize(attributes = {})
      @bank_account        = attributes[:bank_account]
      @amount              = attributes[:amount]
      @description         = attributes[:description]
      @contra_account_name = attributes[:contra_account_name]
    end

  end

end