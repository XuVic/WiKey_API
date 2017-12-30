module Normalize
  
    def normalize(string)
      capitalize_first_word(remove_url(string))
    end
  
    def remove_url(string)
      string.gsub!('%20', ' ')
      string.gsub('_', ' ')
    end
  
    def capitalize_first_word(string)
      if string.include?(' ')
        record = ''
        string = string.split(' ')
        record << string[0].capitalize + ' '
        string[1..string.length-1].each do |word| 
          record << word + ' '
        end
        record.chop
      else
        string.capitalize 
      end
    end
end