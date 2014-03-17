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
task.create_g_answer(answer: '{"bnf":[{"left":null,"rules":[]}], "groups":{"0":{"status":0,"type":"group","data":"Зимой 2014 года в красивый курортный город Сочи впервые смогут","sentence":"0","groupId":3,"groupName":"Н"},"1":{"status":0,"type":"group","data":"приехать спортсмены из раличных стран мира на Олимпийские игры.","sentence":"0","groupId":2,"groupName":"С"},"2":{"status":0,"type":"group","data":"Сколько спортсменов и тренеров из разных стран мира хотят приехать в город Сочи","sentence":"1","groupId":1,"groupName":"П"},"3":{"status":0,"type":"group","data":"с 1 февраля 2014 года по 28 февраля 2014 года на Олимпийские игры?","sentence":"1","groupId":3,"groupName":"Н"},"4":{"status":0,"type":"group","data":"1-го мая 2010 года необходимо срочно отправить в командировку в город","sentence":"2","groupId":5,"groupName":"ИГ 1"},"5":{"status":0,"type":"group","data":"Сочи на олимпийские объекты членов олимпийского комитета РФ.","sentence":"2","groupId":6,"groupName":"ИГ 2"}}}')
task.v_answer.create_bnf
task.v_answer.bnf.bnf_rules.create([{left: '<род>', right: 'мужской | средний'},
  {left: '<число>', right: 'единственное | множественное'}])
k6_224 = Group.create(number: 'K6-224')
st = k6_224.students.create(fio: "Test Student")