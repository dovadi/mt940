class MT940::Ing < MT940::Base

  def self.determine_bank(*args)
    self if args[0].match(/INGBNL/)
  end

end