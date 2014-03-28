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
task.v_answer.create_bnf(bnf_json: {"<число>" => "",
"<род>" => "",
"<одушевленность>" => "",
"<вид>" => "",
"<время>" => "",
"<предлог>" => "",
"<семантический признак>" => "",
"<кодификатор части речи>" => "",
"<падеж>" => "",
"<имя семантической валентности>" => "",
"<лицо>" => "",
 }.to_json)
task.create_s_answer(answer: '[[{"num":"6","word":"","param":"00","level":"0"},{"num":"5","word":"","param":"0","level":"1"}],[{"num":"2","word":"","param":"00","level":"0"},{"num":"4","word":"","param":"0","level":"1"}],[{"num":"5","word":"","param":"00","level":"0"},{"num":"6","word":"","param":"0","level":"1"}]]')

task = Task.create(sentence1: 'По итогам научной конференции МИФИ-2008 срочно произвести награждение   дипломами и премиями МИФИ  лучших студентов в  актовом зале МИФИ с 10 до 12.',
  sentence2: 'Какими дипломами будут награждены лучшие студенты МИФИ в актовом зале в апреле 2008 года?',
  sentence3: 'На научную конференцию в город Н в сентябре 2008 года могут поехать студенты старших курсов МИФИ  с докладами.')
task.create_v_answer
task.create_g_answer(answer: '{"bnf":[{"left":"&lt;G&gt;","rules":[["&lt;Предложение типа вопрос&gt;"],["&lt;Предложение типа сообщение&gt;"],["&lt;Предложение типа команда&gt;"]]},{"left":"&lt;Предложение типа команда&gt;","rules":[["&lt;ИГ 1&gt;","&lt;Предикат&gt;","&lt;ИГ 2&gt;","&lt;ИГ 3&gt;","&lt;ИГ 4&gt;","&lt;ИГ 5&gt;","&lt;ИГ 6&gt;"]]},{"left":"&lt;Предложение типа вопрос&gt;","rules":[["&lt;Вопросительное слово&gt;","&lt;ИГ 2&gt;","&lt;Предикат&gt;","&lt;ИГ 7&gt;","&lt;ИГ 5&gt;","&lt;ИГ 8&gt;"]]},{"left":"&lt;Предложение типа сообщение&gt;","rules":[["&lt;ИГ 5&gt;","&lt;ИГ 9&gt;","&lt;ИГ 8&gt;","&lt;Предикат&gt;","&lt;ИГ 10&gt;","&lt;ИГ 11&gt;"]]},{"left":"&lt;ИГ 1&gt;","rules":[["&lt;Предлог&gt;","&lt;Существительное&gt;","&lt;Прилагательное&gt;","&lt;Существительное&gt;","&lt;Существительное&gt;"]]},{"left":"&lt;ИГ 2&gt;","rules":[["&lt;Существительное&gt;"]]},{"left":"&lt;ИГ 3&gt;","rules":[["&lt;Существительное&gt;","&lt;Существительное&gt;"]]},{"left":"&lt;ИГ 4&gt;","rules":[["&lt;Прилагательное&gt;","&lt;Существительное&gt;"]]},{"left":"&lt;ИГ 5&gt;","rules":[["&lt;Предлог&gt;","&lt;Прилагательное&gt;","&lt;Существительное&gt;","&lt;Существительное&gt;"]]},{"left":"&lt;ИГ 6&gt;","rules":[["&lt;Предлог&gt;","&lt;Числительное&gt;","&lt;Предлог&gt;","&lt;Числительное&gt;"]]},{"left":"&lt;ИГ 7&gt;","rules":[["&lt;Прилагательное&gt;","&lt;Существительное&gt;","&lt;Существительное&gt;"]]},{"left":"&lt;ИГ 8&gt;","rules":[["&lt;Предлог&gt;","&lt;Существительное&gt;","&lt;Числительное&gt;","&lt;Существительное&gt;"]]},{"left":"&lt;ИГ 9&gt;","rules":[["&lt;Предлог&gt;","&lt;Существительное&gt;","&lt;Существительное&gt;"]]},null,{"left":"&lt;ИГ 10&gt;","rules":[["&lt;Существительное&gt;","&lt;Прилагательное&gt;","&lt;Существительное&gt;","&lt;Существительное&gt;"]]},{"left":"&lt;ИГ 11&gt;","rules":[["&lt;Предлог&gt;","&lt;Существительное&gt;"]]},{"left":null,"rules":[]}], "groups":{"0":{"status":0,"type":"group","data":"По итогам научной конференции МИФИ-2008","sentence":"0","groupId":5,"groupName":"ИГ 1"},"1":{"status":0,"type":"group","data":"срочно","sentence":"0","groupId":3,"groupName":"Н"},"2":{"status":0,"type":"group","data":"произвести награждение","sentence":"0","groupId":1,"groupName":"П"},"3":{"status":0,"type":"group","data":"дипломами","sentence":"0","groupId":6,"groupName":"ИГ 2"},"4":{"status":0,"type":"group","data":"и","sentence":"0","groupId":2,"groupName":"С"},"5":{"status":0,"type":"group","data":"премиями МИФИ","sentence":"0","groupId":7,"groupName":"ИГ 3"},"6":{"status":0,"type":"group","data":"лучших студентов","sentence":"0","groupId":8,"groupName":"ИГ 4"},"7":{"status":0,"type":"group","data":"в актовом зале МИФИ","sentence":"0","groupId":9,"groupName":"ИГ 5"},"8":{"status":0,"type":"group","data":"с 10 до 12.","sentence":"0","groupId":10,"groupName":"ИГ 6"},"9":{"status":0,"type":"group","data":"Какими","sentence":"1","groupId":4,"groupName":"ВС"},"10":{"status":0,"type":"group","data":"дипломами","sentence":"1","groupId":6,"groupName":"ИГ 2"},"11":{"status":0,"type":"group","data":"будут награждены","sentence":"1","groupId":1,"groupName":"П"},"12":{"status":0,"type":"group","data":"лучшие студенты МИФИ","sentence":"1","groupId":11,"groupName":"ИГ 7"},"13":{"status":0,"type":"group","data":"в актовом зале","sentence":"1","groupId":9,"groupName":"ИГ 5"},"14":{"status":0,"type":"group","data":"в апреле 2008 года?","sentence":"1","groupId":12,"groupName":"ИГ 8"},"15":{"status":0,"type":"group","data":"На научную конференцию","sentence":"2","groupId":9,"groupName":"ИГ 5"},"16":{"status":0,"type":"group","data":"в город Н","sentence":"2","groupId":13,"groupName":"ИГ 9"},"17":{"status":0,"type":"group","data":"в сентябре 2008 года","sentence":"2","groupId":12,"groupName":"ИГ 8"},"18":{"status":0,"type":"group","data":"могут поехать","sentence":"2","groupId":1,"groupName":"П"},"19":{"status":0,"type":"group","data":"студенты старших курсов МИФИ","sentence":"2","groupId":14,"groupName":"ИГ 10"},"20":{"status":0,"type":"group","data":"с докладами.","sentence":"2","groupId":15,"groupName":"ИГ 11"}}}')
#tempshit
task.v_answer.create_bnf(bnf_json: {"<число>" => "",
"<род>" => "",
"<одушевленность>" => "",
"<вид>" => "",
"<время>" => "",
"<предлог>" => "",
"<семантический признак>" => "",
"<кодификатор части речи>" => "",
"<падеж>" => "",
"<имя семантической валентности>" => "",
"<лицо>" => "",
 }.to_json)
task.create_s_answer(answer: '[[],[],[]]')

k6_224 = Group.create(number: 'K6-224')
st = k6_224.students.create(fio: "Test Student")
testuser = st.create_user(login: 'student0', pass: Digest::MD5.hexdigest('lolka'),
                      role: 'student')
admin = User.create(login: 'admin', pass: Digest::MD5.hexdigest('admin'),
                   role: 'admin')
