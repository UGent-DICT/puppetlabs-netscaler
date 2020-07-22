require_relative '../../../puppet/provider/netscaler'
require 'json'

Puppet::Type.type(:netscaler_policyhttpcallout).provide(:rest, parent: Puppet::Provider::Netscaler) do
  def netscaler_api_type
    'policyhttpcallout'
  end

  def self.instances
    instances = []
    policyhttpcallouts = Puppet::Provider::Netscaler.call('/config/policyhttpcallout')
    return [] if policyhttpcallouts.nil?

    policyhttpcallouts.each do |policyhttpcallout|
      instances << new(ensure: :present,
                       name: policyhttpcallout['name'],
                       ip_address: policyhttpcallout['ipaddress'],
                       port: policyhttpcallout['port'],
                       vserver: policyhttpcallout['vserver'],
                       return_type: policyhttpcallout['returntype'],
                       http_method: policyhttpcallout['httpmethod'],
                       host_expression: policyhttpcallout['hostexpr'],
                       url_stem_expression: policyhttpcallout['urlstemexpr'],
                       headers: policyhttpcallout['headers'],
                       parameters: policyhttpcallout['parameters'],
                       body_expression: policyhttpcallout['bodyexpr'],
                       full_request_expression: policyhttpcallout['fullreqexpr'],
                       scheme: policyhttpcallout['scheme'],
                       result_expression: policyhttpcallout['resultexpr'],
                       cache_time: policyhttpcallout['cacheforsecs'],
                       comment: policyhttpcallout['comment'])
    end

    instances
  end

  mk_resource_methods

  # Map for conversion in the message.
  def property_to_rest_mapping
    {
      ip_address: :ipaddress,
      return_type: :returntype,
      http_method: :httpmethod,
      host_expression: :hostexpr,
      url_stem_expression: :urlstemexpr,
      body_expression: :bodyexpr,
      full_request_expression: :fullreqexpr,
      result_expression: :resultexpr,
      cache_time: :cacheforsecs,
    }
  end

  def immutable_properties
    [
      :return_type,
    ]
  end

  def per_provider_munge(message)
    message
  end
end
