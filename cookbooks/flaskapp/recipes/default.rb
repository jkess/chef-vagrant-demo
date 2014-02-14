#
# Cookbook Name:: flaskapp
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

### communitity cookooks
# knife cookbook site install apache2
include_recipe "apache2"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_wsgi"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_headers"

### install python
# knife cookbook site install python
include_recipe "python"

### create webapp directories
# directory resource: http://docs.opscode.com/chef/resources.html
webappdirs = ['shared', 'web/static']
webappdirs.each do |dir|
  directory "#{node['flaskapp']['path']}/#{dir}" do
    owner node['apache']['user']
    group node['apache']['group']
    mode "0755"
    recursive true
  end
end

### create virtualenv and install py packages
# python_virtualenv and python_pip a resource provided by the python cookbook
# add 'depends python' to 'cookbooks/flaskapp/metadata.rb' to use python cookbook resources
venv = python_virtualenv node['flaskapp']['appname'] do
  path "#{node['flaskapp']['path']}/shared/env"
  interpreter "python2.6" # must use python 2.6 or mod_wsgi won't work
  action :create
end

python_pip 'flask' do
  virtualenv venv.path
  action :install
end

### apache and mod_wsgi config
# write wsgi
template "#{node['flaskapp']['path']}/web/server.wsgi" do
  source "server.wsgi.erb"
  owner node['apache']['user']
  group node['apache']['group']
  variables(
    :appname => node['flaskapp']['appname'],
    :appvenv => "#{node[:flaskapp][:path]}/shared/env"
  )
  notifies :restart, "service[httpd]", :delayed
end

# another apache resource to create virtualhosts
web_app "flaskapp" do
  template 'site.conf.erb'
  docroot "#{node[:flaskapp][:path]}/web"
  server_name node['flaskapp']['appname']
  notifies :restart, "service[httpd]", :delayed
end

### copy of the site file
execute "copy-flask-app" do
  user "root"
  cwd node['flaskapp']['path']
  command <<-EOH
    cp #{node['flaskapp']['source']}/* #{node['flaskapp']['path']}/web
    chown -R #{node['apache']['user']}:#{node['apache']['group']} #{node['flaskapp']['path']}/web
  EOH
end

### make sure httpd is running, restart if apache config changes
service "httpd" do
  supports :restart => true, :reload => true
  action :enable
end
