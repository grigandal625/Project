#coding: utf-8
class Semanticnetwork < ActiveRecord::Base
  belongs_to :etalon
  belongs_to :student
  #метод работает
  
  @predicatEtalon = nil
  @predicatEtalonAlt = nil
  @predicatAnswer = nil


  @nextNodes = []
  @mistakes = []
  @typemistakes = []

  @node1 = nil
  @node2 = nil


  def no_predicat (answer)
  	s_answer = JSON.parse(answer)
  	for i in 0..s_answer.length - 1
  		if (s_answer[i]["predicat"] == true)
			predicat = s_answer[i]["node"]		
  			return 0
  		end
  	end

  	return 100
  end #+
  
  

  def check_predicat(answer, etalon)
	
  	s_answer = JSON.parse(answer) 
  	s_etalon = JSON.parse(etalon) 
	@nextNodes = [] 
	  #@predicatEasy = 0
	  #@predicatHard = 0
	  #@actantCount = 0
	  #@actantName = 0
	  #@actantType = 0
	  #@nodeCount = 0
	  #@nodeName = 0
	  #@nodeType = 0
	@typemistakes = [0,0,0,0,0,0,0,0]

  	for j in 0..s_etalon.length - 1
		@nextNodes.push(s_etalon[j]["node"])
  		for i in 0..s_answer.length - 1	
			if s_answer[i]["predicat"] 
				@predicatAnswer = s_answer[i]["node"]
			end

			if (s_etalon[j]["predicat"]  and s_etalon[j]["alternative"]  )
				s_etalon[j]["predicat"] = false
				@predicatEtalonAlt = s_etalon[j]["node"]
			end

  			if (s_etalon[j]["predicat"] and not (s_etalon[j]["alternative"] ) )
				@predicatEtalon = s_etalon[j]["node"]
			end
  		end
    	end
	

	
	
	if @predicatEtalon == nil  or @predicatAnswer == nil
		@typemistakes[1] += 1
		return 100
	end
	@node1 = SemanticNode.new()
	@node1.updateNode(s_answer)

	@node2 = SemanticNode.new()
	@node2.updateNode(s_etalon)

    	if (@predicatEtalon and @predicatAnswer and @predicatEtalon == @predicatAnswer)

		return 0	
	end
	if (@predicatEtalonAlt and @predicatAnswer and @predicatEtalonAlt == @predicatAnswer)
		@typemistakes[0]  += 1
		return 10	
	end

	@predicatHard += 1
 	return 100
  	
  end #+
  
  
  
  def check_act(answer, etalon)
  	s_answer = JSON.parse(answer) 
  	s_etalon = JSON.parse(etalon) 

	diff =  ( @node1.children.size - @node2.children.size ).abs
	
	if diff == 0
		return 0
	elsif  diff == 1 
		@typemistakes[2] += 1
		return 20
	else 
		@typemistakes[2] += diff
		return 20 + diff * 20
	end
  end
  
  def check_repetition (answer, etalon) #Работает
	mistake = 0
	littleMistake = 0
  	for i in 0..@node2.children.size - 1 
		isFind = false

		for j in 0..@node1.children.size - 1 
			if @node1.children[j].name == @node2.children[i].name && @node1.children[j].deepCase == @node2.children[i].deepCase
				isFind = true
				if @node1.children[j].children.size != @node2.children[i].children.size
					@typemistakes[5]  += 1
					littleMistake += 5
				end
			
			end
			if @node1.children[j].name == @node2.children[i].name && @node1.children[j].deepCase != @node2.children[i].deepCase
				isFind = true
				@typemistakes[4]  += 1
			end
		end
		if not (isFind)
			findNode = @node1.findNode(@node1, @node2.children[i].name)
			if findNode
				findNode.children = []
			end
			@node2.children[i].children = []
			@typemistakes[3]  += 1
			mistake += 1
		end
	end 
  	if mistake == 0
		return 0 + littleMistake
	elsif  mistake == 1 
		return 20 + littleMistake
	else 
		return 20 + mistake * 20 + littleMistake
	end 
  end
  

  
  def check_goodNodes(answer, etalon)
	mistakes = 0
  	for  i in 0..@nextNodes.size
		currentStNode = @node1.findNode(@node1, @nextNodes[i])
		currentEtNode = @node2.findNode(@node2, @nextNodes[i])
		if (currentEtNode and  currentStNode and currentEtNode.type == "Far" )
			if (currentEtNode.deepCase != currentStNode.deepCase)
				@typemistakes[7]  += 1
				mistakes += 5
			end
			if (currentStNode.children.size != currentEtNode.children.size )
				@typemistakes[5]  += 1
				mistakes += 5
			end	
		end
		
		if (currentEtNode and currentEtNode.type == "Far") and ( currentStNode == nil )
  			@typemistakes[6]  += 1
			mistakes += 5
		end
	end
	@mistakes = []
	@mistakes.push({"actantCount":   @typemistakes[0]})
	@mistakes.push({"actantName":    @typemistakes[1]})
	@mistakes.push({"actantType":    @typemistakes[2]})
	@mistakes.push({"nodeCount":     @typemistakes[3]})
	@mistakes.push({"nodeName":      @typemistakes[4]})
	@mistakes.push({"nodeType":      @typemistakes[5]})
	@mistakes.push({"predicatEasy":  @typemistakes[6]})
	@mistakes.push({"predicatHard":  @typemistakes[7]})
	print("-------YYY--------")
	print(@mistakes.to_json)
	self.mistakes = @mistakes.to_s
  	return mistakes
  end
end
