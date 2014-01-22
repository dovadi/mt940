module MT940

  class Account

    attr_accessor :number, :currency, :opening_balance, :closing_balance
    
    def initialize
      @opening_balance = MT940::Balance.new
      @closing_balance = MT940::Balance.new
    end
  end

  class Balance

    attr_accessor :date, :amount

  end


end