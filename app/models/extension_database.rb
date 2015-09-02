
class ExtensionDatabase

	module ExtensionType
	  Knowledge = 1
	  Psycho = 2
	  Skill = 4
	  Other = 8
	end

	class ATExtension
		attr_accessor :name, :controller_class, :ext_type, :description
		attr_accessor :accepts_action, :accepts_task, :generate_state, :task_description, :task_exec_path

		def get_task_description(leaf_id)
			return task_description.call(leaf_id)
		end

		def get_task_exec_path(pddl_act, leaf_id)
			return task_exec_path.call(pddl_act, leaf_id)
		end
	end

	@@singleton = nil
	attr_accessor :extensions

	def initialize(*args)
    	self.extensions = Array.new
    	@@singleton = self
  	end

  	def add(new_ext_name, controller_class)
  		new_ext = controller_class.create_extension() 

  		new_ext.name = new_ext_name
  		new_ext.controller_class = controller_class

  		self.extensions.push(new_ext)
  	end

  	def self.get_extension(ext_name)
  		return self.extensions[0]
  	end

  	def self.get_task_description(task_type, leaf_id)
  		#Find suitable extension
  		found_ext = nil
  		@@singleton.extensions.each do |ext|
  			if((ext.ext_type == task_type) && (ext.accepts_task.call(leaf_id)))
  				found_ext = ext
  				break
  			end
  		end

  		if(found_ext == nil)
  			return "?"
  		else
  			return found_ext.description
  		end
  	end

  	def self.generate_state(mode_id, week_id, schedule)
  		state = {"pending-skills" => [], "pending-knowledge" => [], "pending-psycho" => [], "low-knowledge" => [], "pending-tutoring" => []}

  		@@singleton.extensions.each do |ext|
  			ext.generate_state.call(mode_id, week_id, schedule, state)
  		end

  		return state
  	end

  	def self.get_extension_for_task(task_group, leaf_id)
  		@@singleton.extensions.each do |ext|
  			if(ext.accepts_action.call(task_group) && ext.accepts_task.call(leaf_id))
  				return ext
  			end
  		end

  		return nil
  	end
end

