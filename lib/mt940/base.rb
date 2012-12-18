#encoding: utf-8
module MT940
  class Base

    attr_accessor :bank

    def self.transactions(file)
      process(file, :transactions)
    end

    def self.statements(file)
      process(file, :statements)
    end


    def self.process(file, type)
      file = File.open(file, 'r:utf-8') if file.is_a?(String)
      if file.is_a?(File) || file.is_a?(Tempfile)
        first_line = file.readline
        second_line = file.readline unless file.eof?
        klass = determine_bank(first_line, second_line)
        file.rewind
        instance = klass.new(file)
        file.close
        instance.parse(type)
      else
        raise ArgumentError.new('No file is given!')
      end

    end

    def parse(type = :transactions)
      @tag86 = false
      @lines.each do |line|
        @line = line
        @line.match(/^:(\d{2}F?):/) ? parse_tag($1) : parse_line
      end
      return @statements if type == :statements
      @transactions
    end

    private

    def self.determine_bank(*args)
      Dir.foreach(File.dirname(__FILE__) + '/banks/') do |file|
        if file.match(/\.rb$/)
          klass = eval(file.gsub(/\.rb$/, '').split('_').map { |e| e.capitalize }.join)
          bank  = klass.determine_bank(*args)
          return bank if bank
        end
      end
      self
    end

    def initialize(file)
      @transactions           = []
      @statements             = []
      @statement_transactions = []
      @bank                   = self.class.to_s.split('::').last
      @bank = 'Unknown' if @bank == 'Base'
      @lines = file.readlines
    end

    def parse_tag(tag)
      @tag86 = false if tag.to_s != '86'
      send("parse_tag_#{tag}")
    end

    def parse_tag_25
      @line.gsub!('.', '')
      if @line.match(/^:\d{2}:[^\d]*(\d*)/)
        @bank_account = $1.gsub(/^0/, '')
      end
    end

    def parse_tag_28
      if @line.match(/^:28:(\d{1,5})\/(\d{1,3})/)
        @number, @sequence = $1.to_i, $2.to_i
      end
    end

    def parse_tag_60F
      if @line.match(/^:60F:(C|D)(\d{6})([A-Z]{3})(\d{1,15}),(\d{0,2})/)
        type                      = $1 == 'D' ? -1 : 1
        @opening_balance_amount   = type * BigDecimal.new("#{$4}.#{$5}")
        @opening_balance_currency = $3
        @opening_balance_date     = parse_date($2)
        @currency                 = @line[12..14]
      end
    end

    def parse_tag_61
      if @line.match(/^:61:(\d{6})(C|D)(\d+),(\d{0,2})/)
        type              = $2 == 'D' ? -1 : 1
        @transaction      = MT940::Transaction.new(:bank_account => @bank_account, :amount => type * BigDecimal.new($3 + '.' + $4), :bank => @bank, :currency => @currency)
        @transaction.date = parse_date($1)
        @statement_transactions << @transaction
        @transactions << @transaction
      end
    end

    def parse_tag_62F
      if @line.match(/^:62F:(C|D)(\d{6})([A-Z]{3})(\d{1,15}),(\d{0,2})/)
        type                      = $1 == 'D' ? -1 : 1
        @closing_balance_date     = parse_date($2)
        @closing_balance_currency = $3
        @closing_balance_amount   = type * BigDecimal.new("#{$4}.#{$5}")
        amount_valid              = (@opening_balance_amount + @statement_transactions.inject(0) { |memo, transaction| memo + transaction.amount }) == @closing_balance_amount
        @statements << MT940::Statement.new(
          :number                   => @number,
          :sequence                 => @sequence,
          :bank                     => @bank,
          :bank_account             => @bank_account,
          :opening_balance_amount   => @opening_balance_amount,
          :opening_balance_currency => @opening_balance_currency,
          :opening_balance_date     => @opening_balance_date,
          :closing_balance_amount   => @closing_balance_amount,
          :closing_balance_currency => @closing_balance_currency,
          :closing_balance_date     => @closing_balance_date,
          :amount_valid             => amount_valid,
          :transactions             => @statement_transactions
        )
        @statement_transactions = []
      end
    end


    def parse_tag_86
      if @line.match(/^:86:\s?(.*)$/) && parse_tag_86?
        @tag86                   = true
        @transaction.description ||= ''
        @transaction.description += (@transaction.description == '' ? '' : ' ') + $1.gsub(/>\d{2}/, '')
        @transaction.description.strip!
        parse_contra_account
      end
    end

    def parse_tag_86?
      true
    end

    def parse_line
      if @tag86
        @transaction.description += ' ' + @line.gsub(/\n/, '').gsub(/>\d{2}\s*/, '').gsub(/\-XXX/, '').gsub(/-$/, '').strip
        @transaction.description.strip!
        parse_contra_account
      end
    end

    def parse_date(string)
      Date.new(2000 + string[0..1].to_i, string[2..3].to_i, string[4..5].to_i) if string
    end

    def parse_contra_account
    end

    #Fail silently
    def method_missing(*args)
    end

  end
end