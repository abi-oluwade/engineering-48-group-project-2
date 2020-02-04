#
# Cookbook:: filebeat
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
include_recipe 'apt'

bash 'install_filebeat' do
  user 'root'
  code <<-EOH
  echo "deb https://packages.elastic.co/beats/apt stable main" | sudo tee -a /etc/apt/sources.list.d/beats.list
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D27D666CD88E42B4
  sudo apt-get update && sudo apt-get install filebeat
  sudo /etc/init.d/filebeat start
  EOH
end

template '/etc/filebeat/filebeat.yml' do
  source 'filebeat.yml.erb'
end

execute 'restart Filebeat' do
  command 'sudo /etc/init.d/filebeat restart'
end
