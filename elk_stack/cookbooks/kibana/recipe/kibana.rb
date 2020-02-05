apt_update "update_sources" do
  action :update
end

package "openjdk-8-jdk" do
  action :install
end

bash 'add-bash-https' do
  code 'wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -'
  action :run
end

package "apt-transport-https" do
  action :install
end

apt_repository 'information-keys' do
  uri        'https://artifacts.elastic.co/packages/6.x/apt'
  distribution "stable"
  components ["main"]
  action :add
end

package "kibana" do
  action :install
end

service 'kibana' do
  action :enable
end
service 'kibana' do
  action :start
end

template '/etc/kibana/kibana.yml' do
  source 'kibana.yml.erb'
end
