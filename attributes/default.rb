#
# Cookbook Name:: mwf
# Attributes:: mwf
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

case platform
when "redhat", "centos", "scientific", "fedora", "suse", "amazon", "oracle"
  default['mwf']['dedicated']['owner']    = "apache"
  default['mwf']['dedicated']['group']   = "apache"
  default['mwf']['alias']['owner']    = "apache"
  default['mwf']['alias']['group']   = "apache"
when "debian", "ubuntu"
  default['mwf']['dedicated']['owner']    = "www-data"
  default['mwf']['dedicated']['group']   = "www-data"
  default['mwf']['alias']['owner']    = "www-data"
  default['mwf']['alias']['group']   = "www-data"
when "arch"
  default['mwf']['dedicated']['owner']    = "http"
  default['mwf']['dedicated']['group']   = "http"
  default['mwf']['alias']['owner']    = "http"
  default['mwf']['alias']['group']   = "http"
when "freebsd"
  default['mwf']['dedicated']['owner']    = "www"
  default['mwf']['dedicated']['group']    = "www"
  default['mwf']['alias']['owner']    = "www"
  default['mwf']['alias']['group']    = "www"
else
  default['mwf']['dedicated']['owner']    = "www-data"
  default['mwf']['dedicated']['group']   = "www-data"
  default['mwf']['alias']['owner']    = "www-data"
  default['mwf']['alias']['group']   = "www-data"
end

default['mwf']['dedicated']['enable'] = false
default['mwf']['dedicated']['directory'] = '/var/www/mwf_dedicated'
default['mwf']['dedicated']['hostname'] = '*'
default['mwf']['dedicated']['repository'] = 'https://github.com/ucla/mwf.git'
default['mwf']['dedicated']['reference'] = 'master'
default['mwf']['dedicated']['mode'] = '0755'

default['mwf']['dedicated']['hosts'] = {
  'default' => {
    'enable' => true,
    'directory' => 'default',
  }
}

default['mwf']['alias']['enable'] = false
default['mwf']['alias']['directory'] = '/var/www/mwf'
default['mwf']['alias']['path'] = 'mwf'
default['mwf']['alias']['repository'] = 'https://github.com/ucla/mwf.git'
default['mwf']['alias']['reference'] = 'master'
default['mwf']['alias']['mode'] = '0755'

default['mwf']['alias']['instances'] = {
  'default' => {
    'enable' => true,
    'directory' => 'default',
    'path' => 'mwf'
  }
}