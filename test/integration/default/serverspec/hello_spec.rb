require 'serverspec'

set :backend, :exec

describe 'sinatra app' do
  describe package('ruby1.9.3') do
    it { should be_installed }
  end

  describe package('git') do
    it { should be_installed }
  end

  describe file("/home/hello") do
    it { should be_directory }
  end

  describe service('hello_app') do
    it { should be_running }
  end
end
