HOST := $$(ifconfig | grep 'netmask 255.255.255.0' | awk '{print $$2}')
PORT := 1841

serve:
	bundle _1.17.3_ exec rails server -b ${HOST} -p ${PORT}
ip:
	ifconfig | grep 'netmask 255.255.255.0' | awk '{print $$2}'
start:
	bundle _1.17.3_ exec rails server -b ${HOST} -p ${PORT} -d
stop:
	kill -9 $$(cat tmp/pids/server.pid)
	make stop
webpack:
	bundle _1.17.3_ exec rails webpacker:compile
cptests:
	cp tmp/output/config.txt ../task_generator_mephi/ext/tasks_generator/tests/inputs
	cp tmp/output/topics.txt ../task_generator_mephi/ext/tasks_generator/tests/inputs
	cp tmp/output/questions.txt ../task_generator_mephi/ext/tasks_generator/tests/inputs
	