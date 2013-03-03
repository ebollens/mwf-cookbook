#
# Cookbook Name:: mwf
# Recipe:: mwf
#
# Copyright (c) 2013, Eric Bollens
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, 
#    this list of conditions and the following disclaimer.
#
#  * Redistributions in binary form must reproduce the above copyright notice, 
#    this list of conditions and the following disclaimer in the documentation 
#    and/or other materials provided with the distribution.
#
#  * Neither the name of the University of California nor the names of its 
#    contributors may be used to endorse or promote products derived from this 
#    software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
#

include_recipe "php"
include_recipe "php::module_curl"
include_recipe "php::module_gd"
include_recipe "apache2"
include_recipe "apache2::mod_php5"
  
node['mwf']['dedicated']['hosts'].each do |name, host|
  
  unless host['directory']
    Chef::Log.fatal("All applications defined under mwf['dedicated']['hosts'] require a 'directory' property.")
  end
  
  enabled   = (node['mwf']['dedicated']['enable'] and host['enable'] != false)
  directory = "#{node['mwf']['dedicated']['directory']}/#{host['directory']}"
  www_path  = '/'
  hostname  = host['hostname']
  
  if enabled
    directory Pathname.new(directory).dirname.to_s do
      owner "root"
      group "root"
      mode "0755"
    end
  end
  
  mwf_instance directory do
    
    enable enabled
    path www_path
    git_repository (host['repository'] or node['mwf']['dedicated']['repository'])
    git_reference (host['reference'] or node['mwf']['dedicated']['reference'])
    owner (host['owner'] or node['mwf']['dedicated']['owner'])
    group (host['group'] or node['mwf']['dedicated']['group'])
    mode (host['mode'] or node['mwf']['dedicated']['mode'])
    
  end
  
  web_app "mwf-#{name}" do
    
    enable enabled
    docroot "#{directory}/root"
    template "apache2.dedicated.conf.erb"
    server_name (host['hostname'] or node['mwf']['dedicated']['hostname'])
    server_aliases (host['aliases'] or [])
    
  end
  
  if enabled
    service "apache2" do
      action :restart
    end
  end
  
end

node['mwf']['alias']['instances'].each do |name, instance|
  
  unless instance['directory']
    Chef::Log.fatal("All applications defined under mwf['alias']['instances'] require a 'directory' property.")
  end
  
  enabled = (node['mwf']['alias']['enable'] and instance['enable'] != false)
  directory = "#{node['mwf']['alias']['directory']}/#{instance['directory']}"
  www_path = (instance['path'] or node['mwf']['alias']['path'])
  www_path = "/#{www_path}" unless www_path[0] == '/'
  
  if enabled
    directory Pathname.new(directory).dirname.to_s do
      owner "root"
      group "root"
      mode "0755"
    end
  end
  
  mwf_instance directory do
    
    enable enabled
    path www_path
    git_repository (instance['repository'] or node['mwf']['alias']['repository'])
    git_reference (instance['reference'] or node['mwf']['alias']['reference'])
    owner (instance['owner'] or node['mwf']['alias']['owner'])
    group (instance['group'] or node['mwf']['alias']['group'])
    mode (instance['mode'] or node['mwf']['alias']['mode'])
    
  end
  
  template "#{node['apache']['dir']}/conf.d/alias.mwf.#{name}.conf" do
    cookbook "mwf"
    source "alias.conf.erb"
    variables({
      :path => www_path,
      :directory => "#{directory}/root"
    })
    owner "root"
    group "root"
    mode "0644"
  end
    
  if enabled
    service "apache2" do
      action :restart
    end
  end
  
end