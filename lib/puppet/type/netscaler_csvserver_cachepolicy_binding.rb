require_relative('../../puppet/property/netscaler_truthy')

Puppet::Type.newtype(:netscaler_csvserver_cachepolicy_binding) do
  @doc = 'Manage a binding between a content switching vserver and a cache policy.'

  apply_to_device
  ensurable

  newparam(:name, namevar: true) do
    desc 'csvserver_name/policy_name'
  end

  newproperty(:priority) do
    desc "The priority of the policy binding.

Min = 1
Max = 2147483647"
    newvalues(%r{^\d+$})
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:bindpoint) do
    desc 'The bindpoint to which the policy is bound.Possible values = REQUEST, RESPONSE'
  end

  newproperty(:goto_expression) do
    desc 'Expression specifying the priority of the next policy which will get evaluated if the current policy rule evaluates to TRUE'
  end

  newproperty(:label_name) do
    desc 'Label of policy to invoke if the bound policy evaluates to true.'
  end

  autorequire(:netscaler_csvserver) do
    unless deleting?
      self[:name].split('/')[0]
    end
  end

  autobefore(:netscaler_csvserver) do
    if deleting?
      self[:name].split('/')[0]
    end
  end

  autorequire(:netscaler_cachepolicy) do
    unless deleting?
      self[:name].split('/')[1]
    end
  end

  autobefore(:netscaler_cachepolicy) do
    if deleting?
      self[:name].split('/')[1]
    end
  end

  autorequire(:netscaler_cachepolicylabel) do
    self[:label_name]
  end
end
