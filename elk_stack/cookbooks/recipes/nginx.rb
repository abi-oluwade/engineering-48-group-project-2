include_recipe 'apt'

#packges apt-get
apt_update 'updates_sources' do
  action :update
end

package 'nginx'


service 'nginx' do
  action [ :start, :enable ]
end

# resource template
template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  variables(proxy_port: node['nginx']['proxy_port'])
  notifies :restart, 'service[nginx]'
end

# resource link
link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/default'do
  action :delete
  notifies :restart, 'service[nginx]'
end
