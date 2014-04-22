class Semanticnetwork < ActiveRecord::Base
  belongs_to :etalon
  belongs_to :student
  #метод работает
  
  def no_predicat (answer)
  	s_answer = JSON.parse(answer)
  	for i in 0..s_answer.length - 1
  		if (s_answer[i]["predicat"] == true)
  			
  			return 0
  		end
  	end
  	
  	return 100
  end
  
  def check_predicat(answer, etalon)
  	s_answer = JSON.parse(answer) 
  	s_etalon = JSON.parse(etalon) 
  	
  	
  	for i in 0..s_answer.length - 1
  		for j in 0..s_etalon.length - 1
  		
  			if (s_answer[i]["node"] == s_etalon[j]["node"] && s_answer[i]["predicat"] != s_etalon[j]["predicat"])
  			
  				return 80
  			end
  		end
    end
    return 0
  	
  end
  
  
  
  def check_act(answer, etalon)
  	s_answer = JSON.parse(answer) 
  	s_etalon = JSON.parse(etalon) 
  	
  	
  	for i in 0..s_answer.length - 1
  		for j in 0..s_etalon.length - 1
  		
  			if ( s_etalon[j]["predicat"] == "true" && s_answer[i]["predicat"] == "true")
  				return 20*(s_etalon[j]["connect"].length - s_answer[i]["connect"].length).abs
  			end
  		end
    end
       return 20*(s_etalon[j]["connect"].length - s_answer[i]["connect"].length).abs
  	
  end
  
  def check_repetition (answer) #Работает
  	s_answer = JSON.parse(answer) 
  	
  	for i in 0..s_answer.length - 1
  			if(s_answer[i]["predicat"] == "true")
  			    actantns = Array.new(s_answer[i]["connect"].length)
  			    results =  Array.new()
  				for j in 0..s_answer[i]["connect"].length - 1
  					actantns[j] = s_answer[i]["connect"][j]["deepCase"]
  				end
  				results = actantns & actantns
  				if (results.length != actantns.length)
  					return 20
  				end
  				
  			end
  	end
  	return 0
  end
  
  def check_goodNodes(answer, etalon)
  	s_answer = JSON.parse(answer) 
  	s_etalon = JSON.parse(etalon)
  	
  	for i in 0..s_answer.length - 1
  		for j in 0..s_etalon.length - 1
  			if (s_answer[i]["predicat"] == "true" && s_etalon[i]["predicat"] == "true")
  			  
  				for k in 0..s_answer[i]["connect"].length - 1
  					for l in 0..s_etalon[j]["connect"].length - 1
  						if (s_answer[i]["connect"][k]["to"] == s_etalon[j]["connect"][l]["to"] && 
  						s_answer[i]["connect"][k]["deepCase"] != s_etalon[j]["connect"][l]["deepCase"])
  							print ("----////-----")
  							print(s_answer[i]["connect"][k]["to"])
  							print(s_etalon[j]["connect"][l]["to"])
  							print(s_answer[i]["connect"][k]["deepCase"])
  							print(s_etalon[j]["connect"][l]["deepCase"])
  							return 20
  						end
  						
  					end
  				end
  			end
  		end
  	end 
  	return 0
  end
  
  
  #Метод работает, метод проверяет количество исходящих связей
  def search_outlength(answer, etalon)
  	s_answer = JSON.parse(answer) 
  	s_etalon = JSON.parse(etalon)
  	
  	for i in 0..s_answer.length - 1
  		for j in 0..s_etalon.length - 1
  			if (s_answer[i]["predicat"] != "true" && s_answer[i]["node"] == s_etalon[j]["node"])
  				for k in 0..s_answer[i]["connect"].length
  					for l in 0..s_etalon[j]["connect"].length
  						if (s_answer[i]["connect"].length != s_etalon[j]["connect"].length)
  							return 20
  						end
  					end
  				end
  			end
  		end
  	end 
  	return 0
  end
  	#Метод работает, метод делает проверку корректности глубинных падежей
   def search_deepcase(answer, etalon) 
  	s_answer = JSON.parse(answer) 
  	s_etalon = JSON.parse(etalon)
  	
  	for i in 0..s_answer.length - 1
  		for j in 0..s_etalon.length - 1
  			if (s_answer[i]["predicat"] != "true" && s_answer[i]["node"] == s_etalon[j]["node"])
  			
  				for k in 0..s_answer[i]["connect"].length - 1
  					for l in 0..s_etalon[j]["connect"].length - 1
  						if (s_answer[i]["connect"][k]["to"] == s_etalon[j]["connect"][l]["to"] && 
  						s_answer[i]["connect"][k]["deepCase"] != s_etalon[j]["connect"][l]["deepCase"])
  							return 12
  						end
  						
  					end
  				end
  			end
  		end
  	end 
  	return 0
  end
  
   
  
  
	  
  
end
