#
# Cookbook Name:: Apache Solr
# Recipe:: default
#
# Copyright 2012, Dracars Designs
#
# All rights reserved - Do Not Redistribute
#
# To-Do add attributes to abstract values

execute "download-solr" do
  cwd "/usr/local/share"
  command "wget http://www.gtlib.gatech.edu/pub/apache//lucene/solr/3.6.1/apache-solr-3.6.1.tgz"
  not_if do
    File.exists?("/usr/local/share/apache-solr-3.6.1.tgz")
  end
end

execute "un-tar-solr" do
  cwd "/usr/local/share"
  command "tar xvfz apache-solr-3.6.1.tgz"
  not_if do
    File.exists?("/usr/local/share/apache-solr-3.6.1")
  end
end

execute "rename-solr-folder" do
  cwd "/usr/local/share"
  command "mv apache-solr-3.6.1 apache-solr"
  not_if do
    File.exists?("/usr/local/share/apache-solr")
  end
end

template "/etc/init.d/solr" do
  source "solr.erb"
  mode 0755
end

package "chkconfig"

execute "fix-chkcofig-error" do
  cwd "/sbin"
  command "ln -s ../usr/lib/insserv/insserv"
  not_if do
    File.exists?("/sbin/insserv")
  end
end

execute "set-solr-run-on-reboot" do
  cwd "/etc/init.d/"
  command "chkconfig --add solr"
end

service "solr" do
  action :start
  supports :start => true, :stop => true, :restart => true
end
