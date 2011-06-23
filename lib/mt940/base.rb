module MT940

  class Base

    def self.get_transactions(file_name)
      self.parse_lines(File.readlines(file_name))
    end

    def self.parse_lines(lines)
      raise NoMethodError, 'Code must be implemented in subclass'
    end
  
  end

end
