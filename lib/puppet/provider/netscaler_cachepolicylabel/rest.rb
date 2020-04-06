require_relative '../../../puppet/provider/netscaler'
require 'json'

Puppet::Type.type(:netscaler_cachepolicylabel).provide(:rest, parent: Puppet::Provider::Netscaler) do
  def netscaler_api_type
    'cachepolicylabel'
  end

  def self.instances
    instances = []
    cachepolicylabels = Puppet::Provider::Netscaler.call('/config/cachepolicylabel')
    return [] if cachepolicylabels.nil?

    cachepolicylabels.each do |cachepolicylabel|
      instances << new(ensure: :present,
                       name: cachepolicylabel['labelname'],
                       evaluates: cachepolicylabel['evaluates'])
    end

    instances
  end

  mk_resource_methods

  # Map for conversion in the message.
  def property_to_rest_mapping
    {
      name: :labelname,
    }
  end

  def immutable_properties
    []
  end

  def per_provider_munge(message)
    message
  end
end
