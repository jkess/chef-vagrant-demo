default['flaskapp']['appname'] = "flaskapp"
default['flaskapp']['path'] = "/var/www/flaskapp"

case node.chef_environment
when "prod"
  # prod nfs source
  default['flaskapp']['source'] = "/nfs/release/flaskapp"
when "test"
  default['flaskapp']['source'] = "/nfs/test/flaskapp"
else
  # use local vagrant path
  default['flaskapp']['source'] = "/vagrant/flaskapp"
end
