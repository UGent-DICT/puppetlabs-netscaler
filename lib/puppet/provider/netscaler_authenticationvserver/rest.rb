require_relative '../../../puppet/provider/netscaler'
require 'base64'
require 'json'

Puppet::Type.type(:netscaler_authenticationvserver).provide(:rest, parent: Puppet::Provider::Netscaler) do
  def netscaler_api_type
    'authenticationvserver'
  end

  def self.instances
    instances = []
    servers = Puppet::Provider::Netscaler.call('/config/authenticationvserver')
    return [] if servers.nil?

    #TODO: make sensible property names out of these and apply that to the type.
    servers.each do |server|
      instances << new(ensure: :present,
                       name: server['name'],
                       service_type: server['servicetype'],
                       ip_address: server['ipv46'],
                       range: server['range'],
                       port: server['port'],
                       state: server['state'],
                       authentication: server['authentication'],
                       authentication_domain: server['authenticationdomain'],
                       comment: server['comment'],
                       traffic_domain: server['td'],
                       appflow_logging: server['appflowlog'],
                       max_login_attempts: server['maxloginattempts'],
                       login_fail_timeout: server['failedlogintimeout'])
    end

   instances
  end

  mk_resource_methods

  def property_to_rest_mapping
    {
      service_type: :servicetype,
      ip_address: :ipv46,
      authentication_domain: :authenticationdomain,
      traffic_domain: :td,
      appflow_logging: :appflowlog,
      max_login_attempts: :maxloginattempts,
      login_fail_timeout: :failedlogintimeout,
    }
  end

  def immutable_properties
    [
    ]
  end

  def per_provider_munge(message)
    message
  end
end
