require_relative('../../puppet/property/netscaler_truthy')

Puppet::Type.newtype(:netscaler_lbvserver_servicegroup_binding) do
  @doc = 'Manage a binding between a loadbalancing vserver and a servicegroup.'

  apply_to_device
  ensurable

  newparam(:name, namevar: true) do
    desc 'lbvserver_name/servicegroup_name'
  end

  autorequire(:netscaler_lbvserver) do
    if !self.deleting?
      self[:name].split('/')[0]
    end
  end

  autobefore(:netscaler_lbvserver) do
    if self.deleting?
      self[:name].split('/')[0]
    end
  end

  autorequire(:netscaler_servicegroup) do
    if !self.deleting?
      self[:name].split('/')[1]
    end
  end

  autobefore(:netscaler_servicegroup) do
    if self.deleting?
      self[:name].split('/')[1]
    end
  end
end
