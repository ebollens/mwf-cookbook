#
# Cookbook Name:: mwf
# Definition:: mwf_instance
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

define :mwf_instance, :enable => true, :path => "/", :git_repository => "https://github.com/ucla/mwf.git", :git_reference => "master", :owner => "apache", :group => "apache", :mode => 0755 do
  
  dir_path = params[:name]
  
  if params[:enable]
    
    git dir_path do
      repository params[:git_repository]
      reference params[:git_reference]
      action :sync
    end
    
    directory dir_path do
      owner "root"
      group "root"
      mode "0755"
    end
    
    template "#{dir_path}/config/base.ini" do
      cookbook "mwf"
      source "mwf.base.ini.erb"
       variables({
        :path => params[:path]
      })
      owner "root"
      group "root"
      mode "0644"
    end
    
    directory "#{dir_path}/var" do
      owner params[:owner]
      group params[:group]
      mode params[:mode]
    end
    
  else
    
    directory dir_path do
      action :delete
      recursive true
    end
    
  end
  
end