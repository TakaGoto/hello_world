require 'spec_helper'

describe 'hello::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge('hello::default') }

  it 'installs the httpd' do
    expect(chef_run).to install_package('httpd')
  end

  it 'manages the httpd service' do
    expect(chef_run).to enable_service('httpd')
    expect(chef_run).to start_service('httpd')
  end

  it 'creates index.html' do
    expect(chef_run).to create_file('/var/www/html/index.html').with(
      :content => 'hello there'
      )
  end  
end

