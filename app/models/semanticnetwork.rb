class Semanticnetwork < ActiveRecord::Base
  belongs_to :etalon
  belongs_to :student
  #метод работает
  def check_predicat(answer, etalon)
  	s_answer = JSON.parse(answer) 
  	s_etalon = JSON.parse(etalon) 
  	
  	
  	for i in 0..s_answer.length - 1
  		for j in 0..s_etalon.length - 1
  		
  			if (s_answer[i]["node"] == s_etalon[j]["node"] && s_answer[i]["predicat"] != s_etalon[j]["predicat"])
  			
  				return 40
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
  		
  			if ( s_etalon[j]["predicat"] == "true" && s_answer[i]["predicat"] == "true" &&
  			s_etalon[j]["connect"].length == s_answer[i]["connect"].length)
  				return 0
  			end
  		end
    end
    return 20
  	
  end
  
  def check_repetition (answer, etalon)
  	s_answer = JSON.parse(answer) 
  	s_etalon = JSON.parse(etalon) 
  	for i in 0..s_answer.length - 1
  			if(s_answer[i]["predicat"] == "true")
  				for j in 0..s_answer[i]["connect"].length - 1
  					for k in 0..s_answer[i]["connect"].length - 1
  						if ( k != i && s_answer[i]["connect"][k]["to"] == s_answer[i]["connect"][j]["to"])
  							return 20
  						end
  					end
  				end
  			end
  	end
  	return 0
  end
  
  def check_goodNodes(answer, etalon)
  	s_answer = JSON.parse(answer) 
  	s_etalon = JSON.parse(etalon) 
  	
  	goodnodes = []
  	nodesnotconnect = []
  	for i in 0..s_etalon.length - 1
  		nodesnotconnect.push(s_etalon[i]["node"])
  		if (s_etalon[i]["predicat"] == "true")
  			goodnodes.push(s_etalon[i]["node"])
  		end
  		for j in 0..s_etalon[i]["connect"].length - 1
  			goodnodes.push(s_etalon[i]["connect"][j]["to"])
  		end
  	end
  	nodesnotconnect = nodesnotconnect - goodnodes
  	
  	goodnodessemantic = []
  	nodesnotconnectsemantic = []
  	for i in 0..s_answer.length - 1
  		nodesnotconnectsemantic.push(s_answer[i]["node"])
  		if (s_answer[i]["predicat"] == "true")
  			goodnodessemantic.push(s_answer[i]["node"])
  		end
  		for j in 0..s_answer[i]["connect"].length - 1
  			goodnodessemantic.push(s_answer[i]["connect"][j]["to"])
  		end
  	end
  	nodesnotconnectsemantic = nodesnotconnectsemantic - goodnodessemantic
  	semantic = nodesnotconnectsemantic - nodesnotconnect
  	etalon = nodesnotconnect - nodesnotconnectsemantic
  	if (semantic.length == 0 && etalon.length == 0)
  		return 0
  	end
  	return 20
  		
  end
  #Метод работает, метод проверяет количество исходящих связей
  def search_outlength(answer, etalon)
  	s_answer = JSON.parse(answer) 
  	s_etalon = JSON.parse(etalon)
  	
  	for i in 0..s_answer.length - 1
  		for j in 0..s_etalon.length - 1
  			if (s_answer[i]["node"] == s_etalon[j]["node"])
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
  			if (s_answer[i]["node"] == s_etalon[j]["node"])
  			
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
