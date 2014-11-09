execute 'sudo apt-get update'

package "ruby1.9.3"
package "git"

directory 'hello' do
  path "/home/hello"
  action :create
end

git 'app' do
  repository 'https://github.com/TakaGoto/sinatra.git'
  reference 'master'
  destination '/home/hello'

  action :sync
end

bash 'install bundler' do
  cwd "/home/hello"
  code "gem install bundler"
end

bash 'bundle install' do
  cwd "/home/hello"
  code "bundle install"
end

template "configuration file" do
  path "etc/init/hello_app.conf"
  source "hello/hello_app.conf"
end

service "hello_app" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :stop, :start]
end
