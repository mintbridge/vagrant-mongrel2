
Vagrant::Config.run do |config|

    config.vm.box = "precise32"
    config.vm.network :hostonly, "33.33.33.10"

    config.vm.provision :puppet do |puppet|
        puppet.manifest_file = "init.pp"
        puppet.module_path = "modules"
    end
end
