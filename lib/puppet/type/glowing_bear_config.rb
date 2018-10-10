# lib/puppet/type/glowing_bear_config.rb
Puppet::Type.newtype(:glowing_bear_config) do
  @doc = "Write settings in a Glowing Bear config file"

  newparam(:path, :namevar => true) do
    desc "The path of the config file to generate"
    validate do |value|
      unless Puppet::Util.absolute_path? value
        raise ArgumentError, "glowing bear config path must be absolute: #{value}"
      end
    end
  end

  newparam(:default_path) do
    desc "The path of the default config file to use as template"
    validate do |value|
      unless Puppet::Util.absolute_path? value
        raise ArgumentError, "glowing bear default config path must be absolute: #{value}"
      end
    end
  end

  newparam(:custom_properties) do
    desc "The hash with properties to overwrite"
    validate do |value|
      unless value != nil and value.is_a?(Hash)
        raise ArgumentError, "%s is not a valid properties hash" % value
      end
    end
  end

  ensurable do
    defaultto(:present)
    newvalue(:present) do
      provider.create
    end
  end

end
