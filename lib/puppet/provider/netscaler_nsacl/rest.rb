require_relative '../../../puppet/provider/netscaler'
require 'json'

Puppet::Type.type(:netscaler_nsacl).provide(:rest, {:parent => Puppet::Provider::Netscaler}) do
  def netscaler_api_type
    "nsacl"
  end

  def self.instances
    instances = []
    nsacls = Puppet::Provider::Netscaler.call('/config/nsacl')
    return [] if  nsacls.nil?

    nsacls.each do |nsacl|
      instances << new({
        :ensure         => :present,
        :name           => cachepolicy['aclname'],
        :aclaction      => cachepolicy['aclaction'],
        :td             => cachepolicy['td'],
        :srcip          => cachepolicy['srcip'],
        :srcipop        => cachepolicy['srcipop'],
        :srcipval       => cachepolicy['srcipval'],
        :srcport        => cachepolicy['srcport'],
        :srcportop      => cachepolicy['srcportop'],
        :srcportval     => cachepolicy['srcportval'],
        :destip         => cachepolicy['destip'],
        :destipop       => cachepolicy['destipop'],
        :destipval      => cachepolicy['destipval'],
        :destport       => cachepolicy['destport'],
        :destportop     => cachepolicy['destportop'],
        :destportval    => cachepolicy['destportval'],
        :ttl            => cachepolicy['ttl'],
        :srcmac         => cachepolicy['srcmac'],
        :srcmacmask     => cachepolicy['srcmacmask'],
        :protocol       => cachepolicy['protocol'],
        :protocolnumber => cachepolicy['protocolnumber'],
        :vlan           => cachepolicy['vlan'],
        :vxlan          => cachepolicy['vxlan'],
        :Interface      => cachepolicy['Interface'],
        :established    => cachepolicy['established'],
        :icmptype       => cachepolicy['icmptype'],
        :icmpcode       => cachepolicy['icmpcode'],
        :priority       => cachepolicy['priority'],
        :state          => cachepolicy['state'],
        :logstate       => cachepolicy['logstate'],
        :ratelimit      => cachepolicy['ratelimit'],
        :newname        => cachepolicy['newname'],

      })
    end

    instances
  end

  mk_resource_methods

  # Map for conversion in the message.
  def property_to_rest_mapping
    {
      :name           => :aclname,
    }
  end

  def immutable_properties
    []
  end

  def per_provider_munge(message)
    message
  end
end
