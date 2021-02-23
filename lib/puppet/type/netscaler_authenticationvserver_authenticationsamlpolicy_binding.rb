require_relative('../../puppet/property/netscaler_truthy')

Puppet::Type.newtype(:netscaler_authenticationvserver_authenticationsamlpolicy_binding) do
  @doc = 'Configuration for system authenticationvserver_authenticationsamlpolicy_binding resource.'

  apply_to_device
  ensurable

  newparam(:name, namevar: true)

  newproperty(:policy) do
    desc 'The name of the policy, if any, bound to the authentication vserver.'
  end
  
  newproperty(:priority) do
    desc 'The priority, if any, of the vpn vserver policy.'
    validate do |value|
      unless value.is_a?(Integer)
        raise ArgumentError, 'Priority should be an integer.'
      end
    end
  end

  newproperty(:secondary, parent: Puppet::Property::NetscalerTruthy) do
    truthy_property('Bind the authentication policy to the secondary chain. Provides for multifactor authentication in which a user must authenticate via both a primary authentication method and, afterward, via a secondary authentication method. Because user groups are aggregated across authentication systems, usernames must be the same on all authentication servers. Passwords can be different.', 'true', 'false')
  end

  autorequire(:netscaler_authenticationvserver) do
    unless deleting?
      self[:name].split('/')[0]
    end
  end

  autobefore(:netscaler_authenticationvserver) do
    if deleting?
      self[:name].split('/')[0]
    end
  end

  autorequire(:netscaler_authenticationsamlpolicy) do
    unless deleting?
      self[:name].split('/')[1]
    end
  end

  autobefore(:netscaler_authenticationsamlpolicy) do
    if deleting?
      self[:name].split('/')[1]
    end
  end
end
