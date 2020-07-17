require_relative '../../../puppet/provider/netscaler_binding'

Puppet::Type.type(:netscaler_csvserver_rewritepolicy_binding).provide(:rest, parent: Puppet::Provider::NetscalerBinding) do
  def netscaler_api_type
    'csvserver_rewritepolicy_binding'
  end

  def self.instances
    instances = []
    csvservers = Puppet::Provider::Netscaler.call('/config/csvserver')
    return [] if csvservers.nil?

    csvservers.each do |csvserver|
      binds = Puppet::Provider::Netscaler.call("/config/csvserver_rewritepolicy_binding/#{csvserver['name']}") || []
      binds.each do |bind|
        case bind['labeltype']
        when 'reqvserver'
          vserverlabel = bind['labelname']
        when 'resvserver'
          vserverlabel = bind['labelname']
        when 'policylabel'
          policylabel = bind['labelname']
        end

        case bind['bindpoint']
        when 'REQUEST'
          choose_type = 'Request'
        when 'RESPONSE'
          choose_type = 'Response'
        end

        instances << new(ensure: :present,
                         name: "#{bind['name']}/#{bind['policyname']}",
                         choose_type: choose_type,
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

  def per_provider_munge(message)
    message[:name], message[:policyname] = message[:name].split('/')

    case message[:choose_type]
    when 'Request'
      message[:bindpoint] = 'REQUEST'
    when 'Response'
      message[:bindpoint] = 'RESPONSE'
    end

    if message[:invoke_policy_label]
      message[:labeltype] = 'policylabel'
      message[:labelname] = message[:invoke_policy_label]
      message[:invoke] = 'true'
      message.delete(:invoke_policy_label)
    elsif message[:invoke_vserver_label]
      case message[:choose_type]
      when 'Request'
        message[:labeltype] = 'reqvserver'
      when 'Response'
        message[:labeltype] = 'resvserver'
      end
      message[:labelname] = message[:invoke_vserver_label]
      message[:invoke] = 'true'
      message.delete(:invoke_vserver_label)
    end

    message.delete(:choose_type)

    message
  end
end
