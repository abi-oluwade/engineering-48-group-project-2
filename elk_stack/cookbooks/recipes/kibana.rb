apt_update "update_sources" do
  action :update
end

package "openjdk-8-jdk" do
  action :install
end
# the package for java 8

bash 'add-bash-https' do
  code 'wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -'
  action :run
end
# We need to sign all of our packages with the Elastic Signing Key

package "apt-transport-https" do
  action :install
end
# You need to install the apt-transport-https package on Debian before proceeding

apt_repository 'information-keys' do
  uri        'https://artifacts.elastic.co/packages/6.x/apt'
  distribution "stable"
  components ["main"]
  action :add
end
# We need to store the keys of the https package

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
