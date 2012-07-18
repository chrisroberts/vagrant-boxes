# Chef Vagrant Boxes

These are definitions for building chef based vagrant boxes
using the omnibus installer. Their configuration has been
standardized and any extras removed to get as close to a fresh
install + chef as possible.

Use at your own risk!

## Chef Version

* Current Chef Version: 10.12.0

# Vagrantfile

A Vagrantfile is included to use the boxes available here. Info about
what it provides and how to use it:

## ENV Variables:

* ENV['CHEF_REPO'] - Path to chef repo (defaults to directory containing Vagrant file)
* ENV['DEFAULT_GATEWAY'] - Default gateway for VM (defaults to host default gateway)
* ENV['CHEF_SERVER_URL'] - URL of chef server. Defaults to value in knife.rb
* ENV['CHEF_CLIENT_NAME'] - Name of validation client. Defaults to value in knife.rb
* ENV['CHEF_DEFAULT_RUNLIST'] - Comma separated list of run list items (defaults to empty run list)

## VMs available

* precise - 64bit ubuntu precise server lts
* centos58 - 64bit centos 5.8 server
* centos62 - 64bit centos 6.2 server

These are the default boxes available with the provided Vagrantfile.

## Adding extra VMs

There is a helper for handling the setup in the Vagrantfile. You can use it to
add extra vagrant configs (where two precise nodes may be needed, etc.) Simply
update the Vagrantfile and add a new configuration block within the `Vagrant::Config.run`
block:

```ruby
Vagrant::Config.run do |config|
  ...

  config.vm.define :webserver do |precise_config|
    node_config.call(
      precise_config, 
      :node_name => "webserver.#{username}",
      :run_list => %w(role[web]),
      :box_url => 'https://github.com/downloads/chrisroberts/vagrant-boxes/precise-64.box'
    )
  end
```

Supported args for the node_config call:

* :node_name - name of the node
* :run_list - run list of the node
* :box - name of the box to build from
* :box_url - url of the box to build from
* :hostname - hostname of the node
