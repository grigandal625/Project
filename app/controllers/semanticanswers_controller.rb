#coding: utf-8
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
  
  def destroy
  	Semanticnetwork.find(params[:id]).destroy
  	redirect_to :back
  end 
  
  
  def new
  end
  
  def updatesemanticjson 
  	@semantic = Semanticnetwork.find(params[:id])
    @semantic.mistakes = ""
  	@user = User.find (session["user_id"])
  		if (@user.role == 'admin' || (@user.role == 'student' && !@semantic.iscomplite))
  			@semantic.json = params[:json]
  			
  			result = 100

  			
  			
  			
  			if (@semantic.check_predicat(@semantic.json, @semantic.etalon.etalonjson) > 0 )
  				result -= @semantic.check_predicat(@semantic.json, @semantic.etalon.etalonjson)
          @semantic.mistakes += "Ошибка в предикатной вершине\n"
  			end
  			print ("result p=" )
  			print (result )
  			
  			if (@semantic.check_act(@semantic.json, @semantic.etalon.etalonjson) > 0 )
  				result -= @semantic.check_act(@semantic.json, @semantic.etalon.etalonjson)
          @semantic.mistakes += "Ошибка в определении количества актантов ситуации\n"
  			end
	  			
  			
  			print ("result ac=" )
  			print (result )
  			
  			if (@semantic.check_repetition(@semantic.json) > 0 )
  				result -= @semantic.check_repetition(@semantic.json)
          @semantic.mistakes += "Наличие повторяющихся актантов\n"
  			end
  			
  			if (@semantic.is_not_link(@semantic.json,@semantic.etalon.etalonjson) > 0)
  				result -= @semantic.is_not_link(@semantic.json,@semantic.etalon.etalonjson)
          @semantic.mistakes += "Есть недостающие связи"
  			end 
  			print ("result = repetition" )
  			print (result )
  			
  			if (@semantic.check_goodNodes(@semantic.json,@semantic.etalon.etalonjson) > 0 )
  				result -= @semantic.check_goodNodes(@semantic.json, @semantic.etalon.etalonjson)
          @semantic.mistakes += "Ошибка в определении типа актанта\n"
  			end
  			print ("result =" )
  			print (result)
  			
  			if (@semantic.search_outlength(@semantic.json,@semantic.etalon.etalonjson) > 0 )
  				result -= @semantic.search_outlength(@semantic.json, @semantic.etalon.etalonjson)
          @semantic.mistakes += "Ошибка в определении вершины-понятия\n"
  			end
  			print ("result =" )
  			print (result)
  			
  			if (@semantic.search_deepcase(@semantic.json,@semantic.etalon.etalonjson) > 0 )
  				result -= @semantic.search_deepcase(@semantic.json, @semantic.etalon.etalonjson)
          @semantic.mistakes += "Ошибка в определении типа дуги для очередной вершины\n"
  			end
  			print ("result =" )
  			print ("///////-----////")
  			print (result)
  			if (result > 0 && result < 20)
          @semantic.mistakes += "Очень плохой результат >:-("
  			end
  			if (result >= 20 && result < 40)
          @semantic.mistakes += "Плохой результат :("
  			end
  			if (result >= 40 && result <60)
          @semantic.mistakes += "не самый плохой результат :-| "
  			end
  			if ( result >= 60 && result < 80)
          @semantic.mistakes += "Хороший результат :) "
  			end
  			if ( result >= 80 && result < 100)
          @semantic.mistakes += "Отличный результат :3 "
  			end
  			if ( result == 100)
          @semantic.mistakes += "\m/ Отлично \m/ :3 "
  			end
  			
  			  			
  			if (result < 0 )
  				result = 0
  			end
  				@semantic.rating = result
  				@semantic.iscomplite = true
  				#@semantic.mistakes = mistakes
  				@semantic.save()
  		end
  		render text: @semantic.rating
  	
  end
  
  def getmistakes
  	@semantic = Semanticnetwork.find(params[:id])
  	render text: @semantic.mistakes
  end
end
