module MT940

  class Base

    attr_accessor :bank

    def self.transactions(file)
      file  = File.open(file) if file.is_a?(String) 
      if file.is_a?(File) || file.is_a?(Tempfile)
        first_line  = file.readline
        second_line = file.readline unless file.eof?
        klass       = determine_bank(first_line, second_line)
        file.rewind
        instance = klass.new(file)
        file.close
        instance.parse
      else
        raise ArgumentError.new('No file is given!')
      end
    end

    def parse
      @tag86 = false
      @lines.each do |line|
        @line = line
        @line.match(/^:(\d{2}):/) ? eval('parse_tag_'+ $1) : parse_line
      end
      @transactions
    end

    private

    def self.determine_bank(first_line, second_line)
      if first_line.match(/INGBNL/)
        Ing
      elsif first_line.match(/ABNANL/)
        Abnamro
      elsif first_line.match(/^:940:/)
        Rabobank
      elsif first_line.match(/^:20:/) && second_line && second_line.match(/^:25:TRIODOSBANK/)
        Triodos
      else
        self
      end
    end

    def initialize(file)
      @transactions = []
      @bank  = self.class.to_s.split('::').last
      @bank  = 'Unknown' if @bank == 'Base'
      @lines = file.readlines
    end

    def parse_tag_25
      @line.gsub!('.','')
      if @line.match(/^:\d{2}:[^\d]*(\d*)/)
        @bank_account = $1
        @tag86 = false
      end
    end

    def parse_tag_61
      if @line.match(/^:61:(\d{6})(C|D)(\d+),(\d{0,2})/)
        type = $2 == 'D' ? -1 : 1
        @transaction = MT940::Transaction.new(:bank_account => @bank_account, :amount => type * ($3 + '.' + $4).to_f, :bank => @bank)
        @transaction.date = parse_date($1)
        @transactions << @transaction
        @tag86 = false
      end
    end

    def parse_tag_86
      if !@tag86 && @line.match(/^:86:\s?(.*)$/)
        @tag86 = true
        @transaction.description = $1.gsub(/>\d{2}/,'')
      end
    end

    def parse_line
      @transaction.description += ' ' + @line.gsub(/\n/,'').gsub(/>\d{2}/,'') if @tag86
    end

    def parse_date(string)
      Date.new(2000 + string[0..1].to_i, string[2..3].to_i, string[4..5].to_i) if string
    end

    #Fail silently
    def method_missing(*args)
    end

  end

end
