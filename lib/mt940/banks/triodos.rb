class MT940::Triodos < MT940::Base

  private

  def parse_tag_86
    if @line.match(/^:86:000(.*)$/)
      processed_description = hashify_description($1)

      @transaction.contra_account = if sepa?(processed_description)
        processed_description['21']
      else
        processed_description['10'][/[^0+]\d*/]
      end

      @transaction.description = extract_description(processed_description)
    end
  end

  def bic_code?(text)
     MT940::BIC_CODES.values.include?(text)
  end

  def extract_description(text)
    identifier = sepa?(text) ? 22 : 20
    description = ''
    text.each do |k,v|
      description += v if k.to_i >= identifier && k.to_i < 30
    end
    description
  end

  def hashify_description(description)
    hash = {}
    description.split('>').compact.each do |slice|
      next if slice.empty?
      hash[slice[0..1]] = slice[2..-1]
    end
    hash
  end

  def sepa?(text)
    text['10'] == '0000000000'
  end

end