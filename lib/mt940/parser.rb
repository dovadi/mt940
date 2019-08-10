module MT940
  class NoFileGiven < RuntimeError; end
  class UnknownBank < RuntimeError; end

  class Parser
    attr_accessor :transactions

    def initialize(file)
      file = File.open(file) if file.is_a?(String)
      raise NoFileGiven, 'No file is given!' unless file.is_a?(File) || file.is_a?(Tempfile)

      process(file)
      file.close
    end

    private

    def process(file)
      bank_class = determine_bank_class(file)
      instance   = bank_class.new(file)
      instance.parse
      @transactions = instance.transactions
    rescue NoMethodError => e
      raise UnknownBank, 'Could not determine bank!' if e.message == "undefined method `new' for nil:NilClass"

      raise e
    end

    def determine_bank_class(file)
      case file.readline
      when /^:940:/
        Rabobank
      when /INGBNL/
        Ing
      when /ABNANL/
        Abnamro
      when /^:20:/
        Triodos
      end
    end
  end
end
