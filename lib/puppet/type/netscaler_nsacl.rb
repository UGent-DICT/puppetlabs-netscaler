require_relative('../../puppet/parameter/netscaler_name')
require_relative('../../puppet/property/netscaler_truthy')

Puppet::Type.newtype(:netscaler_nsacl) do
  @doc = 'Manage netscaler acl entry resource'

  apply_to_device
  ensurable

  newparam(:name, parent: Puppet::Parameter::NetscalerName, namevar: true)
  # Name for the extended ACL rule. Must begin with an ASCII alphabetic or underscore (_) character, and must contain only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at (@), equals (=), and hyphen (-) characters. Cannot be changed after the extended ACL rule is created.<br>Minimum length = 1

  newproperty(:aclaction) do
    desc 'Action to perform on incoming IPv4 packets that match the extended ACL rule. Available settings function as follows: * ALLOW - The NetScaler appliance processes the packet. * BRIDGE - The NetScaler appliance bridges the packet to the destination without processing it. * DENY - The NetScaler appliance drops the packet.<br>Possible values = BRIDGE, DENY, ALLOW'
  end

  newproperty(:td) do
    desc 'Integer value that uniquely identifies the traffic domain in which you want to configure the entity. If you do not specify an ID, the entity becomes part of the default traffic domain, which has an ID of 0.<br>Minimum value = 0<br>Maximum value = 4094'
  end

  newproperty(:srcip) do
    desc 'IP address or range of IP addresses to match against the source IP address of an incoming IPv4 packet. In the command line interface, separate the range with a hyphen and enclose within brackets. For example: [10.102.29.30-10.102.29.189].'
  end
  newproperty(:srcipop) do
    desc 'Either the equals (=) or does not equal (!=) logical operator.<br>Possible values = =, !=, EQ, NEQ'
  end

  newproperty(:srcipval) do
    desc 'IP address or range of IP addresses to match against the source IP address of an incoming IPv4 packet. In the command line interface, separate the range with a hyphen and enclose within brackets. For example: [10.102.29.30-10.102.29.189].'
  end

  newproperty(:srcport) do
    desc 'Port number or range of port numbers to match against the source port number of an incoming IPv4 packet. In the command line interface, separate the range with a hyphen and enclose within brackets. For example: [40-90].'
  end

  newproperty(:srcportop) do
    desc 'Either the equals (=) or does not equal (!=) logical operator.<br>Possible values = =, !=, EQ, NEQ'
  end

  newproperty(:srcportval) do
    desc 'Port number or range of port numbers to match against the source port number of an incoming IPv4 packet. In the command line interface, separate the range with a hyphen and enclose within brackets. For example: [40-90].<br>Maximum length = 65535'
  end

  newproperty(:destip) do
    desc 'IP address or range of IP addresses to match against the destination IP address of an incoming IPv4 packet. In the command line interface, separate the range with a hyphen and enclose within brackets. For example: [10.102.29.30-10.102.29.189].'
  end

  newproperty(:destipop) do
    desc 'Either the equals (=) or does not equal (!=) logical operator.<br>Possible values = =, !=, EQ, NEQ'
  end

  newproperty(:destipval) do
    desc 'IP address or range of IP addresses to match against the destination IP address of an incoming IPv4 packet. In the command line interface, separate the range with a hyphen and enclose within brackets. For example: [10.102.29.30-10.102.29.189].'
  end

  newproperty(:destport) do
    desc 'Port number or range of port numbers to match against the destination port number of an incoming IPv4 packet. In the command line interface, separate the range with a hyphen and enclose within brackets. For example: [40-90]. Note: The destination port can be specified only for TCP and UDP protocols.'
  end

  newproperty(:destportop) do
    desc 'Either the equals (=) or does not equal (!=) logical operator.<br>Possible values = =, !=, EQ, NEQ'
  end

  newproperty(:destportval) do
    desc 'Port number or range of port numbers to match against the destination port number of an incoming IPv4 packet. In the command line interface, separate the range with a hyphen and enclose within brackets. For example: [40-90]. Note: The destination port can be specified only for TCP and UDP protocols.<br>Maximum length = 65535'
  end

  newproperty(:ttl) do
    desc 'Number of seconds, in multiples of four, after which the extended ACL rule expires. If you do not want the extended ACL rule to expire, do not specify a TTL value.<br>Minimum value = 1<br>Maximum value = 2147483647'
  end

  newproperty(:srcmac) do
    desc 'MAC address to match against the source MAC address of an incoming IPv4 packet.'
  end

  newproperty(:srcmacmask) do
    desc 'Used to define range of Source MAC address. It takes string of 0 and 1, 0s are for exact match and 1s for wildcard. For matching first 3 bytes of MAC address, srcMacMask'
  end

  newproperty(:protocol) do
    desc 'Protocol to match against the protocol of an incoming IPv4 packet.<br>Possible values = ICMP, IGMP, TCP, EGP, IGP, ARGUS, UDP, RDP, RSVP, EIGRP, L2TP, ISIS'
  end

  newproperty(:protocolnumber) do
    desc 'Protocol to match against the protocol of an incoming IPv4 packet.<br>Minimum value = 1<br>Maximum value = 255'
  end

  newproperty(:vlan) do
    desc 'ID of the VLAN. The NetScaler appliance applies the ACL rule only to the incoming packets of the specified VLAN. If you do not specify a VLAN ID, the appliance applies the ACL rule to the incoming packets on all VLANs.<br>Minimum value = 1<br>Maximum value = 4094'
  end

  newproperty(:vxlan) do
    desc 'ID of the VXLAN. The NetScaler appliance applies the ACL rule only to the incoming packets of the specified VXLAN. If you do not specify a VXLAN ID, the appliance applies the ACL rule to the incoming packets on all VXLANs.<br>Minimum value = 1<br>Maximum value = 16777215'
  end

  newproperty(:interface) do
    desc 'ID of an interface. The NetScaler appliance applies the ACL rule only to the incoming packets from the specified interface. If you do not specify any value, the appliance applies the ACL rule to the incoming packets of all interfaces.'
  end

  newproperty(:established) do
    desc 'Allow only incoming TCP packets that have the ACK or RST bit set, if the action set for the ACL rule is ALLOW and these packets match the other conditions in the ACL rule.'
  end

  newproperty(:icmptype) do
    desc 'ICMP Message type to match against the message type of an incoming ICMP packet. For example, to block DESTINATION UNREACHABLE messages, you must specify 3 as the ICMP type. Note: This parameter can be specified only for the ICMP protocol.<br>Minimum value = 0<br>Maximum value = 65536'
  end

  newproperty(:icmpcode) do
    desc 'Code of a particular ICMP message type to match against the ICMP code of an incoming ICMP packet. For example, to block DESTINATION HOST UNREACHABLE messages, specify 3 as the ICMP type and 1 as the ICMP code. If you set this parameter, you must set the ICMP Type parameter.<br>Minimum value = 0<br>Maximum value = 65536'
  end

  newproperty(:priority) do
    desc 'Priority for the extended ACL rule that determines the order in which it is evaluated relative to the other extended ACL rules. If you do not specify priorities while creating extended ACL rules, the ACL rules are evaluated in the order in which they are created.<br>Minimum value = 1<br>Maximum value = 100000'
  end

  newproperty(:state) do
    desc 'Enable or disable the extended ACL rule. After you apply the extended ACL rules, the NetScaler appliance compares incoming packets against the enabled extended ACL rules.<br>Default value: ENABLED<br>Possible values = ENABLED, DISABLED'
  end

  newproperty(:logstate) do
    desc 'Enable or disable logging of events related to the extended ACL rule. The log messages are stored in the configured syslog or auditlog server.<br>Default value: DISABLED<br>Possible values = ENABLED, DISABLED'
  end

  newproperty(:ratelimit) do
    desc 'Maximum number of log messages to be generated per second. If you set this parameter, you must enable the Log State parameter.<br>Default value: 100<br>Minimum value = 1<br>Maximum value = 10000'
  end

  newproperty(:newname) do
    desc 'New name for the extended ACL rule. Must begin with an ASCII alphabetic or underscore (_) character, and must contain only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at (@), equals (=), and hyphen (-) characters.<br>Minimum length = 1'
  end
end
