require_relative('../../puppet/property/netscaler_truthy')

Puppet::Type.newtype(:netscaler_servicegroup_member) do
  @doc = 'Manage a member of a servicegroup.'

  apply_to_device
  ensurable

  newparam(:name, namevar: true) do
    desc 'servicegroup_name/server_name:server_port'
    validate do |value|
      # This should validate that port is a port
    end
  end

  newproperty(:weight) do
    desc "Weight to assign to the servers in the service group. Specifies the capacity of the servers relative to the other servers in the load balancing configuration. The higher the weight, the higher the percentage of requests sent to the service.

    Min = 1
    Max = 100"
    newvalues(%r{^\d+$})
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:state, parent: Puppet::Property::NetscalerTruthy) do
    truthy_property('The configured state (enable/disable) of the service group.', 'ENABLED', 'DISABLED')
  end

  autorequire(:netscaler_servicegroup) do
    self[:name].split('/')[0]
  end
  autorequire(:netscaler_server) do
    self[:name].split('/')[1].split(':')[0]
  end

  newproperty(:custom_server_id) do
    desc "The identifier for this IP:Port pair. Used when the persistency type is set to Custom Server ID.<br>Default value: 'None'."
  end

  newproperty(:server_id) do
    desc 'The identifier for the service. This is used when the persistency type is set to Custom Server ID.'
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:hash_id) do
    desc "The hash identifier for the service. This must be unique for each service. This parameter is used by hash based load balancing methods.
    Min = 1"
    newvalues(%r{^\d+$})
    munge do |value|
      Integer(value)
    end
  end
end
