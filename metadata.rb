name              "mwf"
maintainer        "Eric Bollens"
maintainer_email  "ebollens@ucla.edu"
license           "BSD 3-clause License"
description       "Installs and configures MWF instances as virtual hosts and aliases"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.2"
recipe            "mwf", "Manage MWF instances based on attribute configuration"

%w{redhat centos scientific fedora debian ubuntu arch freebsd amazon}.each do |os|
  supports os
end

%w{ apache2 git php }.each do |cookbook|
  depends cookbook
end

attribute "mwf",
  :display_name => "MWF hash",
  :description => "Hash of MWF attributes.",
  :type => "hash"

attribute "mwf/dedicated",
  :display_name => "MWF dedicated vhost hash",
  :description => "Hash of MWF dedicated vhost attributes.",
  :default => "hash"

attribute "mwf/dedicated/enable",
  :display_name => "Enable MWF dedicated instances",
  :description => "Boolean whether or not MWF vhosts should be configured. Must be set true to enable any dedicated vhost configuration. Individual vhosts may be enabled or disabled under the vhost hash attribute for the particular vhost.",
  :default => "false"

attribute "mwf/dedicated/directory",
  :display_name => "Directory for MWF dedicated instances",
  :description => "Directory under which MWF dedicated instances will be cloned.",
  :default => "/var/www/mwf_dedicated"

attribute "mwf/dedicated/hostname",
  :display_name => "Default hostname for MWF vhosts",
  :description => "Default hostname for MWF vhosts if not explitely defined within host configuration.",
  :default => "*"

attribute "mwf/dedicated/repository",
  :display_name => "Default Git repository for MWF vhosts",
  :description => "Default respotiroy for MWF vhosts if not explitely defined within host configuration.",
  :default => "https://github.com/ucla/mwf.git"

attribute "mwf/dedicated/reference",
  :display_name => "Default Git branch, tag or commit ID for MWF vhosts",
  :description => "Default Git branch, tag or commit ID for MWF vhosts if not explitely defined within host configuration.",
  :default => "master"

attribute "mwf/dedicated/owner",
  :display_name => "Default owner of MWF var directory for MWF vhosts",
  :description => "Default owner of MWF var directory for MWF vhosts if not explitely defined within host configuration.",
  :default => "node['apache']['user']"

attribute "mwf/dedicated/group",
  :display_name => "Default group of MWF var directory for MWF vhosts",
  :description => "Default group of MWF var directory for MWF vhosts if not explitely defined within host configuration.",
  :default => "node['apache']['group']"

attribute "mwf/dedicated/mode",
  :display_name => "Default mode of MWF var directory for MWF vhosts",
  :description => "Default mode of MWF var directory for MWF vhosts if not explitely defined within host configuration.",
  :default => "0755"

attribute "mwf/dedicated/hosts",
  :display_name => "MWF dedicatedvhosts hash",
  :description => "Hash of MWF hosts where each host is defined by a name as key and hash as value. The hash for the host must minimally contain a directory value, although a hostname is also highly recommended to avoid two vhost definitions over the same hostname.",
  :default => "{'default'=>{'enable'=>true,'hostname'=>'*'}}"

attribute "mwf/alias",
  :display_name => "MWF dedicated alias hash",
  :description => "Hash of MWF dedicated alias attributes.",
  :default => "hash"

attribute "mwf/alias/enable",
  :display_name => "Enable MWF alias instances",
  :description => "Boolean whether or not MWF aliases should be configured. Must be set true to enable any alias configuration. Individual aliases may be enabled or disabled under the instance hash attribute for the particular alias.",
  :default => "false"

attribute "mwf/alias/directory",
  :display_name => "Directory for MWF alias instances",
  :description => "Directory under which MWF alias instances will be cloned.",
  :default => "/var/www/mwf"

attribute "mwf/dedicated/path",
  :display_name => "Default path for MWF aliases",
  :description => "Default path for MWF aliases if not explitely defined within alias configuration.",
  :default => "mwf"

attribute "mwf/alias/repository",
  :display_name => "Default Git repository for MWF alises",
  :description => "Default respotiroy for MWF alises if not explitely defined within alias configuration.",
  :default => "https://github.com/ucla/mwf.git"

attribute "mwf/alias/reference",
  :display_name => "Default Git branch, tag or commit ID for MWF aliases",
  :description => "Default Git branch, tag or commit ID for MWF aliases if not explitely defined within alias configuration.",
  :default => "master"

attribute "mwf/alias/owner",
  :display_name => "Default owner of MWF var directory for MWF aliases",
  :description => "Default owner of MWF var directory for MWF aliases if not explitely defined within alias configuration.",
  :default => "node['apache']['user']"

attribute "mwf/alias/group",
  :display_name => "Default group of MWF var directory for MWF aliases",
  :description => "Default group of MWF var directory for MWF aliases if not explitely defined within alias configuration.",
  :default => "node['apache']['group']"

attribute "mwf/alias/mode",
  :display_name => "Default mode of MWF var directory for MWF aliases",
  :description => "Default mode of MWF var directory for MWF aliases if not explitely defined within alias configuration.",
  :default => "0755"

attribute "mwf/alias/instances",
  :display_name => "MWF alias instances hash",
  :description => "Hash of MWF hosts where each instance is defined by a name as key and hash as value. The hash for the instance must minimally contain a directory value, although a path is also highly recommended to avoid two alias definitions over the same alias.",
  :default => "{'default'=>{'enable'=>true,'directory'=>'default','path'=>'mwf'}}"