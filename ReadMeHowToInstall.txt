Гайд как установить? 
Я буду описывать установку под убунду 14.04 и выше, если у вас другая OS можете не читать этот гайд однако
вы не сможете использовать тестирование даже если соберете проект возникнет конфликт с gem rice. 
Если вы согласны удалите task generator из списка gem-в в Gemfile

Установка на Ubuntu 

ставим все зависимости для Ruby
sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs

устанавливаем rbenv 
cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

вот тут важный шаг вместо последних руби ставим 2.3.3 из за конфликта с gem json 
А так же устанавливаем с опципей включить скрытые библиотеки
CONFIGURE_OPTS="--enable-shared" rbenv install 2.3.3
Делаем эту версию глобальной
rbenv global 2.3.3
Проверяем версию ruby
ruby -v
Понадобится для gem rice
sudo apt-get install autoconf 

install bundler
gem install bundler

устанавливаем Rails (рекомендую 5.0.1, не знаю почему 5.0.2 не пошло) 
для начала требуется поставить nodejs 
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs
затем сами рельсы 
gem install rails -v 5.0.1

rbenv rehash

rails -v
# Rails 5.0.1
_______________________________________
Можете пользоваться. Если запускаете на виртуалке и хотите заходить с др. машинок придется пробросить порт 3000, а так же 
прописывать команду rails s -b 10.0.2.15 ( вместо rails s) 



