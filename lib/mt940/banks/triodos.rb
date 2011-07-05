class MT940::Triodos < MT940::Base

  def self.determine_bank(*args)
    self if args[0].match(/^:20:/) && args[1] && args[1].match(/^:25:TRIODOSBANK/)
  end

end
