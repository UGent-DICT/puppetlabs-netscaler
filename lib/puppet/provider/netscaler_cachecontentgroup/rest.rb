require_relative '../../../puppet/provider/netscaler'
require 'json'

Puppet::Type.type(:netscaler_cachecontentgroup).provide(:rest, parent: Puppet::Provider::Netscaler) do
  def netscaler_api_type
    'cachecontentgroup'
  end

  def self.instances
    instances = []
    cachecontentgroups = Puppet::Provider::Netscaler.call('/config/cachecontentgroup')
    return [] if cachecontentgroups.nil?

    cachecontentgroups.each do |cachecontentgroup|
      instances << new(ensure: :present,
                       name: cachecontentgroup['name'],
                       rel_expiry: cachecontentgroup['relexpiry'],
                       mem_limit: cachecontentgroup['memlimit'],
                       max_response_size: cachecontentgroup['maxressize'])
    end

    instances
  end

  mk_resource_methods

  # Map for conversion in the message.
  def property_to_rest_mapping
    {
      rel_expiry: :relexpiry,
      mem_limit: :memlimit,
      max_response_size: :maxressize,
    }
  end

  def immutable_properties
    []
  end

  def per_provider_munge(message)
    message
  end
end
