require_relative('../../puppet/parameter/netscaler_name')
require_relative('../../puppet/property/netscaler_truthy')

Puppet::Type.newtype(:netscaler_authenticationvserver) do
  @doc = 'Configuration for system authenticationvserver resource.'

  apply_to_device
  ensurable

  newparam(:name, parent: Puppet::Parameter::NetscalerName, namevar: true)

  newproperty(:service_type) do
    desc 'Protocol type of the authentication virtual server. Always SSL.'
  end

  newproperty(:ip_address) do
    desc 'IP address of the authentication virtual server, if a single IP address is assigned to the virtual server.'
  end

  newproperty(:range) do
    desc 'If you are creating a series of virtual servers with a range of IP addresses assigned to them, the length of the range.'
  end

  newproperty(:port) do
    desc 'TCP port on which the virtual server accepts connections.'
  end

  newproperty(:state, parent: Puppet::Property::NetscalerTruthy) do
    truthy_property('Initial state of the new virtual server.', 'ENABLED', 'DISABLED')
  end

  newproperty(:authentication, parent: Puppet::Property::NetscalerTruthy) do
    truthy_property('Require users to be authenticated before sending traffic through this virtual server.', 'ON', 'OFF')
  end

  newproperty(:authentication_domain) do
    desc 'The domain of the authentication cookie set by Authentication vserver.'
  end

  newproperty(:comment) do
    desc 'Any comments associated with this virtual server.'
  end

  newproperty(:traffic_domain) do
    desc 'Integer value that uniquely identifies the traffic domain in which you want to configure the entity. If you do not specify an ID, the entity becomes part of the default traffic domain, which has an ID of 0.'
    validate do |value|
      unless value.is_a?(Integer) && Integer(value).between?(0, 4094)
        raise ArgumentError, 'traffic_domain should be a number between 0 and 4094.'
      end
    end
  end

  newproperty(:appflow_logging, parent: Puppet::Property::NetscalerTruthy) do
    truthy_property('Log AppFlow flow information.', 'ENABLED', 'DISABLED')
  end

  newproperty(:max_login_attempts) do
    desc 'Maximum Number of login attempts.'
    validate do |value|
      unless value.is_a?(Integer) && Integer(value).between?(1, 255)
        raise ArgumentError, 'traffic_domain should be a number between 1 and 255.'
      end
    end
  end

  newproperty(:login_fail_timeout) do
    desc 'Number of minutes an account will be locked if user exceeds maximum permissible attempts.'
  end
end
