username = ENV['OPSCODE_USER'] || ENV['USER']
chef_base = ENV['CHEF_REPO'] || File.expand_path('.')
default_gw = ENV['DEFAULT_GATEWAY'] || %x{ip route show}.split("\n").detect{|l|l.include?('default')}.scan(/\d+\.\d+\.\d+\.\d+/).first
server_url = ENV['CHEF_SERVER_URL']
validation_key = ENV['CHEF_VALIDATION_KEY']
client_name = ENV['CHEF_CLIENT_NAME']
default_run_list = ENV['CHEF_DEFAULT_RUNLIST'] ? ENV['CHEF_DEFAULT_RUNLIST'].split(',') : %w()
if(File.exists?(c = File.join(chef_base, '.chef', 'knife.rb')))
  conf_file = File.readlines(c)
  server_url = conf_file.detect{|l|l.include?('chef_server_url')}.to_s.split(' ').last.gsub(/["']/, '') unless server_url
  client_name = conf_file.detect{|l|l.include?('validation_client_name')}.to_s.split(' ').last.gsub(/["']/, '') unless client_name
  validation_key = File.join(chef_base, '.chef', File.basename(conf_file.detect{|l|l.include?('validation_key')}.to_s.split(' ').last.gsub(/["']/, ''))) unless validation_key
end

node_config = lambda do |config, args|
  args ||= {}
  set_default_gw = "route add default gw #{default_gw};"
  if(args[:box_url])
    config.vm.box_url = args[:box_url]
  else
    config.vm.box_url = 'https://github.com/downloads/chrisroberts/vagrant-boxes/precise-64.box'
  end
  if(args[:box])
    config.vm.box = args[:box]
  else
    config.vm.box = File.basename(config.vm.box_url).sub('.box', '')
  end
  config.vm.customize do |vm|
    vm.memory_size = 1024
  end
  config.vm.provision :shell do |shell|
    shell.inline = "/etc/init.d/ntp stop; ntpdate pool.ntp.org; #{set_default_gw}"
  end
  config.vm.network :bridged
  config.vm.host_name = args[:hostname] || args[:node_name].split('.').first
  config.vm.provision :chef_client do |chef|
    chef.chef_server_url = server_url
    chef.validation_key_path = validation_key
    chef.validation_client_name = client_name
    chef.node_name = args[:node_name]
    chef.run_list = args[:run_list] || default_run_list
  end
end

Vagrant::Config.run do |config|
  config.vm.define :precise do |precise_config|
    node_config.call(
      precise_config, 
      :node_name => "precise.#{username}",
      :box_url => 'https://github.com/downloads/chrisroberts/vagrant-boxes/precise-64.box'
    )
  end
  
  config.vm.define :centos58 do |centos58_config|
    node_config.call(
      centos58_config,
      :node_name => "centos58.#{username}",
      :run_list => %w(role[base]),
      :box_url => 'https://github.com/downloads/chrisroberts/vagrant-boxes/centos58-64.box'
    )
  end

  config.vm.define :centos62 do |centos62_config|
    node_config.call(
      centos62_config,
      :node_name => "centos62.#{username}",
      :run_list => %w(role[base]),
      :box_url => 'https://github.com/downloads/chrisroberts/vagrant-boxes/centos62-64.box'
    )
  end

end
