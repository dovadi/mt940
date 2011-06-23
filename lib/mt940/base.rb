module MT940

  class Base

    def self.transactions(file_name)
      instance = self.new(file_name)
      instance.parse
      instance.instance_variable_get('@transactions')
    end

    private

    def initialize(file_name)
      @transactions = []
      @lines = File.readlines(file_name)
    end

    def parse
      raise NoMethodError, 'Code must be implemented in subclass'
    end

  end

end
