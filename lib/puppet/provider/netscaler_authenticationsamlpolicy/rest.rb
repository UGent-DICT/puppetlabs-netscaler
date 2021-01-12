require_relative '../../../puppet/provider/netscaler'
require 'base64'
require 'json'

Puppet::Type.type(:netscaler_authenticationsamlpolicy).provide(:rest, parent: Puppet::Provider::Netscaler) do
  def netscaler_api_type
    'authenticationsamlpolicy'
  end

  def self.instances
    instances = []
    policies = Puppet::Provider::Netscaler.call('/config/authenticationsamlpolicy')
    return [] if policies.nil?

    policies.each do |policy|
      instances << new(ensure: :present,
                       name: policy['name'],
                       rule: policy['rule'],
                       request_action: policy['reqaction'])
    end

    instances
  end

  mk_resource_methods

  # Map for conversion in the message.
  def property_to_rest_mapping
    {
      request_action: :reqaction,
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
