#encoding: utf-8
#This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
task = Task.create(sentence1: 'Зимой 2014 года в красивый курортный город Сочи впервые смогут приехать спортсмены из раличных стран мира на Олимпийские игры.',
  sentence2: 'Сколько спортсменов и тренеров из разных стран мира хотят приехать в город Сочи с 1 февраля 2014 года по 28 февраля 2014 года на Олимпийские игры?',
  sentence3: '1-го мая 2010 года необходимо срочно отправить в командировку в город Сочи на олимпийские объекты членов олимпийского комитета РФ.')
task.create_v_answer
task.create_g_answer(answer: '{"bnf":[{"left":"&lt;G&gt;","rules":[["&lt;Предложение типа вопрос&gt;"],["&lt;Предложение типа сообщение&gt;"],["&lt;Предложение типа команда&gt;"]]},{"left":null,"rules":[]}], "groups":{"0":{"status":0,"type":"group","data":"Зимой 2014 года","sentence":"0","groupId":5,"groupName":"ИГ 1"},"1":{"status":0,"type":"group","data":"в красивый курортный город Сочи","sentence":"0","groupId":6,"groupName":"ИГ 2"},"2":{"status":0,"type":"group","data":"впервые","sentence":"0","groupId":3,"groupName":"Н"},"3":{"status":0,"type":"group","data":"смогут приехать","sentence":"0","groupId":1,"groupName":"П"},"4":{"status":0,"type":"group","data":"спортсмены из раличных стран мира","sentence":"0","groupId":7,"groupName":"ИГ 3"},"5":{"status":0,"type":"group","data":"на Олимпийские игры.","sentence":"0","groupId":8,"groupName":"ИГ 4"},"6":{"status":0,"type":"group","data":"Сколько","sentence":"1","groupId":4,"groupName":"ВС"},"7":{"status":0,"type":"group","data":"спортсменов","sentence":"1","groupId":9,"groupName":"ИГ 5"},"8":{"status":0,"type":"group","data":"и","sentence":"1","groupId":2,"groupName":"С"},"9":{"status":0,"type":"group","data":"тренеров из разных стран мира","sentence":"1","groupId":7,"groupName":"ИГ 3"},"10":{"status":0,"type":"group","data":"хотят приехать","sentence":"1","groupId":1,"groupName":"П"},"11":{"status":0,"type":"group","data":"в город Сочи","sentence":"1","groupId":10,"groupName":"ИГ 6"},"12":{"status":0,"type":"group","data":"с 1 февраля 2014 года","sentence":"1","groupId":11,"groupName":"ИГ 7"},"13":{"status":0,"type":"group","data":"по 28 февраля 2014 года","sentence":"1","groupId":11,"groupName":"ИГ 7"},"14":{"status":0,"type":"group","data":"на Олимпийские игры?","sentence":"1","groupId":8,"groupName":"ИГ 4"},"15":{"status":0,"type":"group","data":"1-го мая 2010 года","sentence":"2","groupId":12,"groupName":"ИГ 8"},"16":{"status":0,"type":"group","data":"необходимо срочно отправить в командировку","sentence":"2","groupId":1,"groupName":"П"},"17":{"status":0,"type":"group","data":"в город Сочи на олимпийские объекты","sentence":"2","groupId":13,"groupName":"ИГ 9"},"18":{"status":0,"type":"group","data":"членов олимпийского комитета РФ.","sentence":"2","groupId":13,"groupName":"ИГ 10"}}}')
task.v_answer.create_bnf
task.v_answer.bnf.bnf_rules.create([{left: '<род>', right: 'Мужской | Средний'},
  {left: '<число>', right: 'Единственное | Множественное'},
  {left: '<одушевленность>', right: ''},
  {left: '<вид>', right: ''},
  {left: '<время>', right: ''},
  {left: '<предлог>', right: ''},
  {left: '<семантический признак>', right: ''},
  {left: '<кодификатор части речи>', right: ''},
  {left: '<падеж>', right: ''},
  {left: '<имя семантической валентности>', right: ''}])
k6_224 = Group.create(number: 'K6-224')
st = k6_224.students.create(fio: "Test Student")
testuser = st.create_user(login: 'student0', pass: Digest::MD5.hexdigest('lolka'),
                      role: 'student')
admin = User.create(login: 'admin', pass: Digest::MD5.hexdigest('admin'),
                   role: 'admin')
task.create_s_answer(answer: '[[{"num":"6","word":"","param":"00","level":"0"},{"num":"5","word":"","param":"0","level":"1"}],[{"num":"2","word":"","param":"00","level":"0"},{"num":"4","word":"","param":"0","level":"1"}],[{"num":"5","word":"","param":"00","level":"0"},{"num":"6","word":"","param":"0","level":"1"}]]')
