require 'spec_helper'

describe 'hadoop::hive_server2' do
  context 'on Centos 6.4 x86_64' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4) do |node|
        node.automatic['domain'] = 'example.com'
        node.default['hive']['hive_site']['hive.support.concurrency'] = 'true'
        node.default['hive']['hive_site']['hive.zookeeper.quorum'] = 'localhost'
        stub_command('update-alternatives --display hadoop-conf | grep best | awk \'{print $5}\' | grep /etc/hadoop/conf.chef').and_return(false)
        stub_command('update-alternatives --display hive-conf | grep best | awk \'{print $5}\' | grep /etc/hive/conf.chef').and_return(false)
      end.converge(described_recipe)
    end

    it 'does not install hive-server2 package' do
      expect(chef_run).not_to install_package('hive-server2')
    end
  end
  context 'on Centos 6.4 x86_64 with CDH' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4) do |node|
        node.automatic['domain'] = 'example.com'
        node.override['hadoop']['distribution'] = 'cdh'
        node.default['hive']['hive_site']['hive.support.concurrency'] = 'true'
        node.default['hive']['hive_site']['hive.zookeeper.quorum'] = 'localhost'
        stub_command('update-alternatives --display hadoop-conf | grep best | awk \'{print $5}\' | grep /etc/hadoop/conf.chef').and_return(false)
        stub_command('update-alternatives --display hive-conf | grep best | awk \'{print $5}\' | grep /etc/hive/conf.chef').and_return(false)
      end.converge(described_recipe)
    end

    it 'install hive-server2 package' do
      expect(chef_run).to install_package('hive-server2')
    end
  end
end