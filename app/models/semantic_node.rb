#coding: utf-8
class SemanticNode 
  attr_accessor :name
  attr_accessor :type
  attr_accessor :deepCase
  attr_accessor :parent
  attr_accessor :children
  attr_accessor :inputJson
  attr_accessor :nextSearchNodes
  attr_accessor :stepNodes
  def initialize

  end

  def updateNode(inputJson)
	@inputJson = inputJson
	@nextSearchNodes = []
	@stepNodes = []

	for i in 0..inputJson.length - 1
		if inputJson[i]["predicat"]
			@name = inputJson[i]["node"]
			@type = "predicat"
			@deepCase = "None"
			@parent = nil
			@children = []
			for l in 0..inputJson[i]["connect"].length - 1
				child = SemanticNode.new
				child.name = inputJson[i]["connect"][l]["to"]
				child.deepCase = inputJson[i]["connect"][l]["deepCase"]
				child.type = "Actant"
				child.parent = @name
				child.children = []
				@children.push(child)
				@nextSearchNodes.push(child.name)
  			end
		end
	end
	
	@stepNodes.push( @name)
	step
	@inputJson = ""
  end

  def step
	for i in 0..@nextSearchNodes.length - 1
		node = findNode(self ,@nextSearchNodes[i])
		if(node)
			stepNodes.push(node.name)
			newobject = findJsonNode(node.name)

			for j in 0..newobject["connect"].length - 1
				child = SemanticNode.new
				child.name = newobject["connect"][j]["to"]
				child.deepCase = newobject["connect"][j]["deepCase"]
				child.type = "Far"
				child.parent = node.name
				child.children = []
				node.children.push(child)
				if  not (@stepNodes.include?(child.name)) 
 					@nextSearchNodes.push(child.name)
				end
			end
		else
			@stepNodes.push(@nextSearchNodes[i])
		end				
	end	

	@nextSearchNodes -= @stepNodes
	if (@nextSearchNodes.size > 0)
		step
	end
  end

  def findJsonNode(namae )
	for i in 0..@inputJson.length
		if @inputJson[i]["node"] == namae

			return  @inputJson[i]
		end
	end
	return nil
  end

  def findNode(node, namae)
	if (namae == node.name)
		return node
	end 
	  for i in 0..node.children.length - 1
		if (findNode(node.children[i], namae))
			return findNode(node.children[i],namae)
		end
	  end 
	  return nil
	
  end

end
