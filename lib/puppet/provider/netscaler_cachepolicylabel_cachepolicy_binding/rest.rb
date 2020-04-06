require_relative '../../../puppet/provider/netscaler_binding'

Puppet::Type.type(:netscaler_cachepolicylabel_cachepolicy_binding).provide(:rest, parent: Puppet::Provider::NetscalerBinding) do
  def netscaler_api_type
    'cachepolicylabel_cachepolicy_binding'
  end

  def self.instances
    instances = []
    cachepolicylabels = Puppet::Provider::Netscaler.call('/config/cachepolicylabel')
    return [] if cachepolicylabels.nil?

    cachepolicylabels.each do |cachepolicylabel|
      binds = Puppet::Provider::Netscaler.call("/config/cachepolicylabel_cachepolicy_binding/#{cachepolicylabel['labelname']}") || []
      binds.each do |bind|
        instances << new(ensure: :present,
                         name: "#{bind['labelname']}/#{bind['policyname']}",
                         priority: bind['priority'],
                         goto_expression: bind['gotopriorityexpression'],
                         invoke_policy_label: bind['invoke_labelname'],
      end
    end

    instances
  end

  mk_resource_methods

  def property_to_rest_mapping
    {
      goto_expression: :gotopriorityexpression,
      invoke_policy_label: :invoke_labelname,
    }
  end

  def per_provider_munge(message)
    message[:labelname], message[:policyname] = message[:name].split('/')

    if message[:invoke_labelname]
      message[:labeltype] = 'policylabel'
      message[:invoke] = 'true'
    end

    message
  end
end
