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
	
build:
	docker buildx build -f ./docker/Dockerfile -t at-tutoring-old:latest . 
run:
	docker rm -f at_tutoring_old 2>/dev/null || true
	docker run --name at_tutoring_old -v "db:/app/db" -d -p 1841:1841 at-tutoring-old:latest 
down:
	docker rm -f at_tutoring_old 2>/dev/null || true