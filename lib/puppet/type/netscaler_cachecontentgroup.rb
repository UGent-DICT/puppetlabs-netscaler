require_relative('../../puppet/parameter/netscaler_name')
require_relative('../../puppet/property/netscaler_truthy')

Puppet::Type.newtype(:netscaler_cachecontentgroup) do
  @doc = 'Manage netscaler Cache content group entry resource'

  apply_to_device
  ensurable

  newparam(:name, parent: Puppet::Parameter::NetscalerName, namevar: true)
  # Name for the extended ACL rule. Must begin with an ASCII alphabetic or underscore (_) character, and must contain only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at (@), equals (=), and hyphen (-) characters. Cannot be changed after the extended ACL rule is created.<br>Minimum length = 1

  newproperty(:rel_expiry) do
    desc 'Relative expiry time, in seconds, after which to expire an object cached in this content group. Minimum value = 0. Maximum value = 31536000'
  end

  newproperty(:mem_limit) do
    desc 'Maximum amount of memory that the cache can use. The effective limit is based on the available memory of the NetScaler appliance. Default value: 65536'
  end

  newproperty(:max_response_size) do
    desc 'Maximum size of a response that can be cached in this content group (in kb). Default value: 80. Minumum 0, maximum 2097151.'
  end
end
