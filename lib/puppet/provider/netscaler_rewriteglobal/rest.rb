require_relative '../../../puppet/provider/netscaler_binding'

Puppet::Type.type(:netscaler_rewriteglobal).provide(:rest, parent: Puppet::Provider::NetscalerBinding) do
  def netscaler_api_type
    'rewriteglobal_rewritepolicy_binding'
  end

  def self.instances
    instances = []
    rewritepolicies = Puppet::Provider::Netscaler.call('/config/rewritepolicy')
    return [] if rewritepolicies.nil?

    rewritepolicies.each do |policy|
      binds = Puppet::Provider::Netscaler.call("/config/rewritepolicy_rewriteglobal_binding/#{policy['name']}") || []

      binds.each do |bind|
        case bind['labeltype']
        when 'reqvserver'
          vserverlabel = bind['labelname']
          labeltype = 'Request'
        when 'resvserver'
          vserverlabel = bind['labelname']
          labeltype = 'Response'
        when 'policylabel'
          policylabel = bind['labelname']
        end
        instances << new(ensure: :present,
                         name: bind['name'],
                         connection_type: labeltype,
                         priority: bind['priority'],
                         goto_expression: bind['gotopriorityexpression'],
                         invoke_policy_label: policylabel,
                         invoke_vserver_label: vserverlabel)
      end
    end

    instances
  end

  mk_resource_methods

  def property_to_rest_mapping
    {
      goto_expression: :gotopriorityexpression,
    }
  end

  def immutable_properties
    [
      :priority,
      :goto_expression,
    ]
  end

  def destroy
    result = Puppet::Provider::Netscaler.delete('/config/rewriteglobal_rewritepolicy_binding', 'args' => "policyname:#{resource.name}")
    @property_hash.clear

    result
  end

  def per_provider_munge(message)
    message[:policyname] = message[:name]
    if message[:invoke_policy_label]
      message[:labeltype] = 'policylabel'
      message[:labelname] = message[:invoke_policy_label]
      message[:invoke] = 'true'
      message.delete(:invoke_policy_label)
    elsif message[:invoke_vserver_label]
      case message[:connection_type]
      when 'Request'
        message[:labeltype] = 'reqvserver'
      when 'Response'
        message[:labeltype] = 'resvserver'
      end
      message[:labelname] = message[:invoke_vserver_label]
      message[:invoke] = 'true'
      message.delete(:invoke_vserver_label)
    end

    message.delete(:name)
    message.delete(:connection_type)
    message
  end
end
