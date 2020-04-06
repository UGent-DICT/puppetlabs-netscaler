require_relative('../../puppet/property/netscaler_truthy')

Puppet::Type.newtype(:netscaler_cachepolicylabel_cachepolicy_binding) do
  @doc = 'Manage a binding between a content switching vserver and a content switching policy.'

  apply_to_device
  ensurable

  newparam(:name, namevar: true) do
    desc 'cachepolicylabel_name/cachepolicy_name'
  end

  newproperty(:priority) do
    desc 'Specifies the priority of the policy.'
    newvalues(%r{^\d+$})
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:goto_expression) do
    desc 'Expression specifying the priority of the next policy which will get evaluated if the current policy rule evaluates to TRUE'
  end

  newproperty(:invoke_policy_label) do
    desc 'Label of policy to invoke if the bound policy evaluates to true.'
  end

  autorequire(:netscaler_cachepolicylabel) do
    if !self.deleting?
      [
        self[:name].split('/')[0],
        self[:invoke_policy_label],
      ]
    end
  end

  autobefore(:netscaler_cachepolicylabel) do
    if self.deleting?
      [
        self[:name].split('/')[0],
        self[:invoke_policy_label],
      ]
    end
  end

  autorequire(:netscaler_cachepolicy) do
    if !self.deleting?
      self[:name].split('/')[1]
    end
  end

  autobefore(:netscaler_cachepolicy) do
    if self.deleting?
      self[:name].split('/')[1]
    end
  end
end
