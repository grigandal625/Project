class SemanticanswersController < ActionController::Base
skip_before_filter :verify_authenticity_token
  def index
  		@user = User.find (session["user_id"])
  		if (@user.role == "admin")
  			@tests = Semanticnetwork.all
	
  		else
  			redirect_to :root
  		end
  end
	
  def create 
    @semantic = Semanticnetwork.new()
    @semantic.rating = 0;
    @semantic.etalon = Etalon.find(:all, :order => "RANDOM()", :limit => 1).first
    @semantic.json = ""
    @semantic.student = User.find(session[:user_id]).student
    @semantic.save()
    redirect_to semanticanswer_path(@semantic.id)
  end
  
  def show
  	@semantic = Semanticnetwork.find(params[:id])
  end
  
  def result
     @student = Student.find(params[:id])

  end
  
  def new
  end
  
  def updatesemanticjson 
  	@semantic = Semanticnetwork.find(params[:id])
  	@user = User.find (session["user_id"])
  		if (@user.role == 'admin' || (@user.role == 'student' && !@semantic.iscomplite))
  			@semantic.json = params[:json]
  			result = 100
  			result -= @semantic.no_predicat(@semantic.json)
  			result -= @semantic.check_predicat(@semantic.json, @semantic.etalon.etalonjson)
  			print ("result p=" )
  			print (result )
  			result -= @semantic.check_act(@semantic.json, @semantic.etalon.etalonjson)
  			print ("result ac=" )
  			print (result )
  			result -= @semantic.check_repetition(@semantic.json)
  			print ("result = repetition" )
  			print (result )
  			result -= @semantic.check_goodNodes(@semantic.json, @semantic.etalon.etalonjson)
  			print ("result =" )
  			print (result)
  			result -= @semantic.search_outlength(@semantic.json, @semantic.etalon.etalonjson)
  			print ("result =" )
  			print (result)
  			result -= @semantic.search_deepcase(@semantic.json, @semantic.etalon.etalonjson)
  			print ("result =" )
  			print ("///////-----////")
  			print (result)
  			if (result < 0 )
  				result = 0
  			end
  				@semantic.rating = result
  				@semantic.iscomplite = true
  				@semantic.save()
  		end
  		render text: @semantic.rating
  	
  end
end
