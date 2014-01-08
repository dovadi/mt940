class MT940::Triodos < MT940::Base

  private

  def parse_tag_86
    if @line.match(/^:86:000(.*)$/)
      processed_description = hashify_description($1)

      if bic_code?(processed_description['20'])

      else
        description = ''
        processed_description.each do |k,v|
          description += v if k[0] == '2'
        end
        @transaction.description = description
      end

      @transaction.contra_account = processed_description['10'][/[^0+]\d*/]
    end
  end

  def bic_code?(text)
     Mt940::BIC_CODES.values.include?(text)
  end

  def hashify_description(description)
    hash = {}
    description.split('>').compact.each do |slice|
      next if slice.empty?
      hash[slice[0..1]] = slice[2..-1]
    end
    hash
  end

end
