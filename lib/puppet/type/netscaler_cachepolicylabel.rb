require_relative('../../puppet/parameter/netscaler_name')
require_relative('../../puppet/property/netscaler_truthy')
require_relative('../../puppet/property/netscaler_traffic_domain')

Puppet::Type.newtype(:netscaler_cachepolicylabel) do
  @doc = 'Manage a Netscaler cachepolicy label.'

  apply_to_device
  ensurable

  newparam(:name, parent: Puppet::Parameter::NetscalerName, namevar: true)

  newproperty(:evaluates) do
    desc 'When to evaluate policies bound to this label: request-time or response-time.'
    validate do |value|
      if [
        :REQ,
        :RES,
        :MSSQL_REQ,
        :MSSQL_RES,
        :MYSQL_REQ,
        :MYSQL_RES,
      ].none? { |s| s.to_s.eql? value }
        raise ArgumentError, 'Valid options: REQ, RES, MSSQL_REQ, MSSQL_RES, MYSQL_REQ, MYSQL_RES'
      end
    end

    munge(&:upcase)
  end
end
