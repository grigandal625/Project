#coding: utf-8
class AdminpanelController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
     user = User.find_by(id: session[:user_id])
    
  if user.role!='admin'
    redirect_to root_url
  end

  
  end
#   def getCSV
#     time = Time.now.utc.to_i 
#     if params[:met]=='forward'
#       title='Ведомости / Прямой вывод'
#     else
#       title='Ведомости / Обратный вывод'
#     end
#     s = '<html><head><meta charset="utf-8"> <link href="/js/css/vedomosti.css" rel="stylesheet" /></head><body><table border="1" cellpadding="5"><tr><td colspan="3"><h1>'+title+'</h1></td></tr><tr class="title"><td>Группа</td><td>ФИО</td><td>Результат</td></tr>'
#     date_time = (Time.at(time).strftime("%d.%m.%Y")).to_s
#     name_file = params[:group]+'_'+params[:met]+'_'+(Time.at(time).strftime("%H_%M_%S")).to_s

# @result=Result.find_by_sql("SELECT * FROM results  INNER JOIN users ON results.user_id=users.id and results.action='"+params[:met]+"' and strftime('%d.%m.%Y', datetime(results.timeend, 'unixepoch'))='"+params[:year]+"'")
 
#   @result.each do |row| 
#     if row.group==params[:group]
#    s=s+'<tr><td>'+row.group+'</td><td>'+row.fio+'</td><td>'+row.result.to_s+'</td></tr>'
#    end
#   end
#   s=s+'</table></body></html>'
#    Dir.mkdir('public/results/'+date_time) unless File.exists?('public/results/'+date_time)
#   f = File.open('public/results/'+date_time+'/'+name_file+'.html','w:UTF-8')
#   f.puts(s.encode('UTF-8'))
#   f.close()
 
#  render :text => '/results/'+date_time+'/'+name_file+'.html'

#   end
 #  def getBothMethod
 #    time = Time.now.utc.to_i 
 #    s = '<html><head><meta charset="utf-8"> <link href="/js/css/vedomosti.css" rel="stylesheet" /></head><body><table border="1" cellpadding="5" width="100%"><tr><td colspan="3"><h1>Ведомости / Прямой вывод</h1></td></tr><tr class="title"><td>Группа</td><td>ФИО</td><td>Результат</td></tr>'
 #    date_time = (Time.at(time).strftime("%d.%m.%Y")).to_s
 #    name_file = params[:group]+'_'+params[:met]+'_'+(Time.at(time).strftime("%H_%M_%S")).to_s

 #   @result=Result.find_by_sql("SELECT * FROM results  INNER JOIN users ON results.user_id=users.id and results.action='forward' and strftime('%d.%m.%Y', datetime(results.timeend, 'unixepoch'))='"+params[:year]+"'")
 
 #  @result.each do |row| 
 #    if row.group==params[:group]
 #   s=s+'<tr><td>'+row.group+'</td><td>'+row.fio+'</td><td>'+row.result.to_s+'</td></tr>'
 #   end
 #  end
 #  s=s+'</table><br />'
  
 #  s=s+'<table border="1" cellpadding="5" width="100%"><tr><td colspan="3"><h1>Ведомости / Обратный вывод</h1></td></tr><tr class="title"><td>Группа</td><td>ФИО</td><td>Результат</td></tr>'
 #  @result=Result.find_by_sql("SELECT * FROM results  INNER JOIN users ON results.user_id=users.id and results.action='reverse' and strftime('%d.%m.%Y', datetime(results.timeend, 'unixepoch'))='"+params[:year]+"'")
 
 #  @result.each do |row| 
 #    if row.group==params[:group]
 #   s=s+'<tr><td>'+row.group+'</td><td>'+row.fio+'</td><td>'+row.result.to_s+'</td></tr>'
 #   end
 #  end
 #  s=s+'</table></body></html>'
 #   Dir.mkdir('public/results/'+date_time) unless File.exists?('public/results/'+date_time)
  
 #  f = File.open('public/results/'+date_time+'/'+name_file+'.html','w:UTF-8')
 #  f.puts(s.encode('UTF-8'))
 #  f.close()
 
 # render :text => '/results/'+date_time+'/'+name_file+'.html'
 #  end
  
  def saveJSON
    time = Time.now.utc.to_i 
    date_time = (Time.at(time).strftime("%d.%m.%Y")).to_s
    name_file = (params[:name]+'_'+params[:met]).to_s

   Dir.mkdir('public/JSON/') unless File.exists?('public/JSON/')
  f = File.open('public/JSON/'+name_file+'.json','w:UTF-8')
  f.puts(params[:jsonstring])
  f.close()
 
 render :text => '/JSON/'+name_file+'.json'
  end
end
