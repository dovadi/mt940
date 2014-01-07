class MT940::Triodos < MT940::Base

  private

  def parse_tag_86
    if @line.match(/^:86:000(.*)$/)
      
      sliced_description = $1.split('>')
      processed_description = {}
      $1.split('>').compact.each do |slice|
        next if slice.empty?
        processed_description[slice[0..1]] = slice[2..-1]
      end

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

end
