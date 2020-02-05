#
# Cookbook:: elk_stack
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

apt_update 'update ubuntu' do
  action :update
end

apt_package 'openjdk-8-jdk' do
  action :install
end

elasticsearch_user 'elasticsearch' do
  action :nothing
end

elasticsearch_install 'elasticsearch' do
  type :package
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml.erb'
end

service 'elasticsearch' do
  action [:enable, :start]
end
