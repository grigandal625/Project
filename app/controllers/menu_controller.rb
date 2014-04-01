class MenuController < ApplicationController
	def index	
	user = User.find (session[:user_id])
		if (user.role == "admin")
			redirect_to groups_path
		end
	end
	
	def results
		@semantic = Semanticnetwork.all
		
	end
end
