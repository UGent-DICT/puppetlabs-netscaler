require_relative '../../../puppet/provider/netscaler_binding'

Puppet::Type.type(:netscaler_authenticationvserver_authenticationsamlpolicy_binding).provide(:rest, parent: Puppet::Provider::NetscalerBinding) do
  def netscaler_api_type
    'authenticationvserver_authenticationsamlpolicy_binding'
  end

  def self.instances
    instances = []
    authvservers = Puppet::Provider::Netscaler.call('/config/authenticationvserver')
    return [] if authvservers.nil?

    authvservers.each do |authvserver|
      bindings = Puppet::Provider::Netscaler.call("/config/authenticationvserver_authenticationsamlpolicy_binding/#{authvserver['name']}") || []
      bindings.each do |binding|
        instances << new(ensure: :present,
                         name: "#{binding['name']}/#{binding['policy']}",
                         priority: binding['priority'],
                         secondary: binding['secondary'])
      end
    end

    instances
  end

  mk_resource_methods

  def property_to_rest_mapping
    {
    }
  end

  def per_provider_munge(message)
    message[:name], message[:policy] = message[:name].split('/')

    message
  end

  def destroy
    toname, fromname = resource.name.split('/').map { |n| URI.escape(n) }
    result = Puppet::Provider::Netscaler.delete("/config/#{netscaler_api_type}/#{toname}", 'args' => "policy:#{fromname}")
    @property_hash.clear

    result
  end
end
