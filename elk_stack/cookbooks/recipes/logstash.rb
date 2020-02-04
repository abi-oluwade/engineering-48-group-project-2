# -- logstash recipe-------------------------------------------
# update ubuntu
apt_update 'update ubuntu' do
  action :update
end

# Java install
apt_package 'openjdk-8-jdk' do
  action :install
end

# Sourcelist. Import public key as logstash
execute 'logstash_wget_key' do
  command 'sudo wget https://download.elastic.co/logstash/logstash/packages/debian/logstash_2.3.4-1_all.deb'
  action :run
end

# Logstash update
execute 'logstash_install' do
  command 'dpkg -i logstash_2.3.4-1_all.deb'
  action :run
end

# Logstash update
execute 'logstash_update' do
  command 'sudo update-rc.d logstash defaults 97 8'
  action :run
end

# Service start
execute 'logstash_start' do
  command 'sudo service logstash start'
  action :run
end

# Service restart
execute 'logstash_status' do
  command 'sudo service logstash status'
  action :run
end
