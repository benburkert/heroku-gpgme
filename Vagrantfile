Vagrant::Config.run do |config|
  config.vm.box = "lucid64"
  config.vm.box_url = "http://files.vagrantup.com/lucid64.box"
  config.vm.network("33.33.33.10")
  config.vm.provision :shell, :path => "provision.sh"
  config.vm.share_folder("Root Share", "/root/share", "share", :nfs => true)
end
