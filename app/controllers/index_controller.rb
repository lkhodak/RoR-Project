require 'mock_CTO_model'

class IndexController < ApplicationController
  
  def index
    @ctosByRating=getCTOByRating
  end
  
  
  #Really this should be get from database
  def getCTOByRating
    @CTOArray= Array.new
    
    #generate mockup model

    (0..10).each {|i|
     @arrayElement = CTOMock.new(i,"test1","aff1",i)
     @CTOArray.append(@arrayElement)
     }
    
   return  @CTOArray
  end
end
