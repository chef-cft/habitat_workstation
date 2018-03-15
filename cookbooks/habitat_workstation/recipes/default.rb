#
# Cookbook Name:: habitat_workstation
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe 'yum-epel::default'

apt_update 'periodic apt update' do
  action :periodic
end

user 'hab' do
  manage_home false
  system true
  uid 500
end

group 'hab' do
  members ['hab']
  gid 500
end

package %w( git tree vim emacs nano jq curl tmux )

docker_service 'default' do
  action [:create, :start]
end

user 'chef' do
  comment 'ChefDK User'
  manage_home true
  home '/home/chef'
  shell '/bin/bash'
  # chef
  # password '$1$seaspong$/UREL79gaEZJRXoYPaKnE.'
  # devopsdays
  # password '$1$c0ZYNwlj$Mc4gPTMFVu/4QfZQlQ3k71'
  # habitat
  password '$1$O8xTKqhe$c1LNYkTGAX8ZnC6ISl0VQ.'
  action :create
end

group 'docker' do
  action :modify
  members 'chef'
  append true
end

sudo 'chef' do
  template 'chef-sudoer.erb'
end

if node['platform_family'] == 'rhel'
  service 'sshd'

  execute 'allow port 443 for ssh' do
    command 'semanage port -m -t ssh_port_t  -p tcp 443'
    notifies :restart, 'service[sshd]'
  end

  template '/etc/ssh/sshd_config' do
    source 'rhel-sshd_config.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[sshd]'
  end

  directory '/etc/cloud' do
    recursive true
  end

  template '/etc/cloud/cloud.cfg' do
    source 'cloud.cfg.erb'
    owner 'root'
    group 'root'
    mode '0644'
  end
end

if node['platform_family'] == 'debian'
  include_recipe 'ufw::disable'
  service 'ssh'

  template '/etc/ssh/sshd_config' do
    source 'debian-sshd_config.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[ssh]'
  end
end

hab_install 'install habitat' do
  not_if { node['hab']['version'] == 'none' }
end

cookbook_file '/home/chef/new-mongodb-config.toml' do
  source 'new-mongodb-config.toml'
  owner 'chef'
  group 'chef'
  mode '0664'
end

cookbook_file '/home/chef/new-plan.sh' do
  source 'new-plan.sh'
  owner 'chef'
  group 'chef'
  mode '0664'
end

git '/home/chef/sample-node-app' do
  repository 'https://github.com/habitat-sh/sample-node-app.git'
  revision 'master'
  action :sync
  user 'chef'
  group 'chef'
end

cookbook_file '/home/chef/sample-node-app/new-config.toml' do
  source 'new-config.toml'
  owner 'chef'
  group 'chef'
  mode '0664'
end

include_recipe 'habitat_workstation::docker_compose'
