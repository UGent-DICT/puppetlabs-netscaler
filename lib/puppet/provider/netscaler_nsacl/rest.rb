require_relative '../../../puppet/provider/netscaler'
require 'json'

Puppet::Type.type(:netscaler_nsacl).provide(:rest, parent: Puppet::Provider::Netscaler) do
  def netscaler_api_type
    'nsacl'
  end

  def self.instances
    instances = []
    nsacls = Puppet::Provider::Netscaler.call('/config/nsacl')
    return [] if nsacls.nil?

    nsacls.each do |nsacl|
      instances << new(ensure: :present,
                       name: nsacl['aclname'],
                       aclaction: nsacl['aclaction'],
                       td: nsacl['td'],
                       srcip: nsacl['srcip'] || !nsacl['srcipval'].nil? ? true : nil,
                       srcipop: nsacl['srcipop'],
                       srcipval: nsacl['srcipval'],
                       srcport: nsacl['srcport'],
                       srcportop: nsacl['srcportop'],
                       srcportval: nsacl['srcportval'],
                       destip: nsacl['destip'] || !nsacl['destipval'].nil? ? true : nil,
                       destipop: nsacl['destipop'],
                       destipval: nsacl['destipval'],
                       destport: nsacl['destport'],
                       destportop: nsacl['destportop'],
                       destportval: nsacl['destportval'],
                       ttl: nsacl['ttl'],
                       srcmac: nsacl['srcmac'],
                       srcmacmask: nsacl['srcmacmask'],
                       protocol: nsacl['protocol'],
                       protocolnumber: nsacl['protocolnumber'],
                       vlan: nsacl['vlan'],
                       vxlan: nsacl['vxlan'],
                       interface: nsacl['Interface'],
                       established: nsacl['established'],
                       icmptype: nsacl['icmptype'],
                       icmpcode: nsacl['icmpcode'],
                       priority: nsacl['priority'],
                       state: nsacl['state'],
                       logstate: nsacl['logstate'],
                       ratelimit: nsacl['ratelimit'],
                       newname: nsacl['newname'])
    end

    instances
  end

  mk_resource_methods

  # Map for conversion in the message.
  def property_to_rest_mapping
    {
      name: :aclname,
      interface: :Interface,
    }
  end

  def immutable_properties
    []
  end

  def per_provider_munge(message)
    message
  end
end
