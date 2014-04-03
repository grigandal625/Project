class MenuController < ApplicationController
	def index	

		if (@user.role == "admin")
			redirect_to groups_path
		end
	end
	
	def results
		@semantic = Semanticnetwork.all
		
	end
end
