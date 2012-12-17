module MT940
  class Statement

    attr_accessor :number, :sequence, :bank, :bank_account, :opening_balance_amount,
                  :opening_balance_currency, :opening_balance_date, :plain, :closing_balance_amount,
                  :closing_balance_currency, :closing_balance_date, :transactions, :amount_valid

    def initialize(attributes = {})
      @number                   = attributes[:number]
      @sequence                 = attributes[:sequence]
      @bank                     = attributes[:bank]
      @bank_account             = attributes[:bank_account]
      @opening_balance_amount   = attributes[:opening_balance_amount]
      @opening_balance_currency = attributes[:opening_balance_currency]
      @opening_balance_date     = attributes[:opening_balance_date]
      @closing_balance_amount   = attributes[:closing_balance_amount]
      @closing_balance_currency = attributes[:closing_balance_currency]
      @closing_balance_date     = attributes[:closing_balance_date]
      @plain                    = attributes[:plain]
      @amount_valid             = attributes[:amount_valid]
      @transactions             = attributes[:transactions]
    end

  end
end