execute 'install unzip' do
  command 'apt-get install unzip'
  action :run
end

execute 'install curl' do
  command 'apt-get install curl'
  action :run
end

execute 'beats dashboard download' do
  command 'curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip'
  action :run
end

execute 'unzip' do
  command 'unzip beats-dashboards-1.1.0.zip'
  action :run
end

execute 'run beats' do
  command 'cd beats-dashboards-1.1.0 # ./load.sh'
  action :run
end

execute 'filebeat template' do
  command 'curl -O https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json'
  action :run
end

execute 'filebeat verify' do
  command 'curl -XPUT http://212.161.55.68/_template/filebeat?pretty -d@filebeat-index-template.json'
  action :run
end
