class MT940::Ing < MT940::Base

  def self.determine_bank(*args)
    self if args[0].match(/INGBNL/)
  end

  def parse_contra_account
    if @transaction && @transaction.description.match(/^\d(\d{9})(.+)/)
       @transaction.contra_account = $1
       @transaction.description = $2.strip
     end
  end

  def parse_tag_86?
    @transaction.description.nil?
  end
end