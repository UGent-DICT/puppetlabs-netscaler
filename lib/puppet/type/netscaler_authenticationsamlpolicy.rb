require_relative('../../puppet/parameter/netscaler_name')

Puppet::Type.newtype(:netscaler_authenticationsamlpolicy) do
  @doc = 'Configuration for system authenticationsamlpolicy resource.'

  apply_to_device
  ensurable

  newparam(:name, parent: Puppet::Parameter::NetscalerName, namevar: true)

  newproperty(:rule) do
    desc 'Name of the NetScaler named rule, or a default syntax expression, that the policy uses to determine whether to attempt to authenticate the user with the SAML server.'
  end

  newproperty(:request_action) do
    desc 'Name of the SAML authentication action to be performed if the policy matches.'
  end
end
