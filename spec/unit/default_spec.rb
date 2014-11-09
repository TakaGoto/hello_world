require 'spec_helper'

describe 'hello::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge('hello::default') }

  it 'creates a directory for the app' do
    expect(chef_run).to create_directory('hello')
  end

  it 'updates ubuntu' do
    expect(chef_run).to run_execute('sudo apt-get update')
  end

  it 'installs the httpd' do
    expect(chef_run).to install_package('git')
  end

  it 'installs ruby 1.9.3' do
    expect(chef_run).to install_package('ruby1.9.3')
  end

  it 'installs bundler' do
    expect(chef_run).to run_bash('install bundler').with(
      :code => "gem install bundler"
    )
  end

  it 'bundle installs the gems' do
    expect(chef_run).to run_bash('bundle install').with(
      :cwd => "/home/hello",
      :code => "bundle install"
    )
  end

  it 'creates template for config file' do
    expect(chef_run).to create_template('configuration file').with(
      :source => "hello/hello_app.conf",
      :path => "etc/init/hello_app.conf"
    )
  end

  it 'clones hello sinatra app' do
    expect(chef_run).to sync_git('app').with(
      :repository => 'https://github.com/TakaGoto/sinatra.git',
      :reference => 'master',
      :destination => '/home/hello'
    )
  end

  describe "hello app service" do
    it 'starts hello app' do
      expect(chef_run).to start_service('hello_app').with(
        :provider => Chef::Provider::Service::Upstart
      )
    end

    it 'stops hello app' do
      expect(chef_run).to stop_service('hello_app').with(
        :provider => Chef::Provider::Service::Upstart
      )
    end

    it 'enables hello app' do
      expect(chef_run).to enable_service('hello_app').with(
        :provider => Chef::Provider::Service::Upstart
      )
    end
  end
end
