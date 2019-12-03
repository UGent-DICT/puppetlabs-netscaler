Puppet::Type.newtype(:netscaler_feature) do
  desc 'Netscaler features'

  apply_to_device

  ensurable

  def self.rest_name_map
    {
      'wl'                 => 'Web Logging',
      'sp'                 => 'Surge Protection',
      'lb'                 => 'Load Balancing',
      'cs'                 => 'Content Switching',
      'cr'                 => 'Cache Redirection',
      'sc'                 => 'Sure Connect',
      'cmp'                => 'Compression Control',
      'pq'                 => 'Priority Queuing',
      'ssl'                => 'SSL Offloading',
      'gslb'               => 'Global Server Load Balancing',
      'hdosp'              => 'Http DoS Protection',
      'cf'                 => 'Content Filtering',
      'ic'                 => 'Integrated Caching',
      'sslvpn'             => 'SSL VPN',
      'aaa'                => 'AAA',
      'ospf'               => 'OSPF Routing',
      'rip'                => 'RIP Routing',
      'bgp'                => 'BGP Routing',
      'rewrite'            => 'Rewrite',
      'ipv6pt'             => 'IPv6 protocol translation',
      'appfw'              => 'Application Firewall',
      'responder'          => 'Responder',
      'htmlinjection'      => 'HTML Injection',
      'push'               => 'NetScaler Push',
      'appflow'            => 'AppFlow',
      'cloudbridge'        => 'CloudBridge',
      'isis'               => 'ISIS Routing',
      'ch'                 => 'CallHome',
      'appqoe'             => 'AppQoE',
      'diskcaching'        => 'Integrated Disk Caching',
      'vpath'              => 'vPath',
      'contentaccelerator' => 'Content Accelerator',
      'rise'               => 'RISE',
      'feo'                => 'Front End Optimization',
    }
  end

  newparam(:name, namevar: true) do
    desc 'Feature name'

    validate do |value|
      if Puppet::Type::Netscaler_feature.rest_name_map.values.none? { |s| s <=> value }
        raise ArgumentError, 'Valid options: ' + Puppet::Type::Netscaler_feature.rest_name_map.values.to_s
      end
    end
  end

  def self.title_patterns
    key_pattern = rest_name_map.keys.join('|')
    [
      [%r{^(#{key_pattern})$}i, [[:name, proc { |value| rest_name_map[value.downcase] }]]],
      [%r{(.*)}m, [[:name]]],
    ]
  end
end
