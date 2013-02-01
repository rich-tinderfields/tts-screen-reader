class Page < ActiveRecord::Base
  attr_accessible :body, :title
  
  
  def self.check_100_chars(text)
    if text.length <=100
      return [text]
    end
    
    words_array = text_at_100_chars.split(" ")
    first_array = words_array.slice(0,(words_array.length/2).celi)
    second_array = words_array.slice((words_array.length/2).celi, words_array.length)
    
    raise first_array.inspect, second_array.inspect
    
  end
  
end
