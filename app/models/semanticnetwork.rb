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
  @typemistakes = [0,0,0,0,0,0,0,0]
  @typemistakesComment = []


  @node1 = nil
  @node2 = nil
  
  @logcomments = []
  
 
  def check_predicat(answer, etalon)
    @logcomments = []
  	s_answer = JSON.parse(answer)
  	s_etalon = JSON.parse(etalon) 
    allnodesSize = s_etalon.size
	
	  @node1 = SemanticNode.new()
	  @node1.updateNode(s_answer)

	  @node2 = SemanticNode.new()
	  @node2.updateNode(s_etalon)

    
    rank = 0
    mult = 45.0

    otherMult = 55.0


    studentNode = @node1.name.to_s
    etalonNode = @node2.name.to_s
    if studentNode == etalonNode 
      rank += 5
      @logcomments.push(" Predicat Correct ")
    else
      @logcomments.push(" Predicat Incorrect ")
      return [rank, @logcomments]
    end  

    #print("---- ActSize ---")
    actSize = @node2.children.size
    #print (actSize)

    otherNodesSize = allnodesSize - actSize - 1
    eachBonus = ((mult - 5) / actSize ) / 2
    eachSmallBonus = (otherMult) / (2*otherNodesSize)
    
    for originalActant in @node2.children 
      studentActant  = @node1.findNode(@node1, originalActant.name)
      if ( not studentActant)
          reducemultipleOnAllNodes(@node1, true)
          reducemultipleOnAllNodes(@node1, true)
      end
    end

    for originalActant in @node2.children 
      studentActant  = @node1.findNode(@node1, originalActant.name)
      if ( not studentActant)
        @logcomments.push("No Actant " + originalActant.name)
      elsif studentActant.type == originalActant.type
        rank += eachBonus * studentActant.multiple

        if studentActant.deepCase == originalActant.deepCase
          rank += eachBonus * studentActant.multiple
          @logcomments.push(studentActant.name + " deepCase Correct ")
        else
          @logcomments.push(studentActant.name + " deepCase Incorrect ")
          reducemultipleOnAllNodes(studentActant, true)
        end
        branchrank = searchBranch(studentActant, originalActant,  eachSmallBonus)
        #print( "Branch Rank ----")
        #print(branchrank)
        rank += branchrank
      else

        @logcomments.push(studentActant.name + " type Incorrect ")
        originalActant.children = []
      end
    end
    

    
    #print(@logcomments)
    #print ("\n \n")
    #print(@node1.to_json)
    #print(rank)

    return [rank, @logcomments]
  	
  end #+

  def searchBranch(nodeS, nodeE, eachSmallBonus)
    branchrank = 0
    for curS in nodeS.children
      isFind = false
      for curE in nodeE.children
        if curE.name == curS.name
          isFind = true
          branchrank += eachSmallBonus * curE.multiple
          if not ( curE.deepCase == curS.deepCase )
            reducemultipleOnAllNodes(curS, true)
            @logcomments.push(curE.name + " Ok but not Type " + (eachSmallBonus * curS.multiple).to_s )
          else
            @logcomments.push(curE.name + " Ok " + (eachSmallBonus * curS.multiple * 2).to_s )
            branchrank += eachSmallBonus * curS.multiple
          end
        end
      end
      if isFind
        branchrank += searchBranch(curS, curE, eachSmallBonus)
      else 
        @logcomments.push(curS.name + " No Have 0 ")
        curS.children = []
      end
    end
    return branchrank
  end

  def reducemultipleOnAllNodes(node, isFinish)
    for curnode in node.children
      curnode.multiple = curnode.multiple * 0.5
      reducemultipleOnAllNodes(curnode, false)
    end

    if isFinish
      return node
    end
  end
  

end
