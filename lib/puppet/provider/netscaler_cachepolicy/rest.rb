require_relative '../../../puppet/provider/netscaler'
require 'json'

Puppet::Type.type(:netscaler_cachepolicy).provide(:rest, {:parent => Puppet::Provider::Netscaler}) do
  def netscaler_api_type
    "cachepolicy"
  end

  def self.instances
    instances = []
    cachepolicys = Puppet::Provider::Netscaler.call('/config/cachepolicy')
    return [] if  cachepolicys.nil?

    cachepolicys.each do |cachepolicy|
      instances << new({
        :ensure         => :present,
        :name           => cachepolicy['policyname'],
        :expression     => cachepolicy['rule'],
        :action         => cachepolicy['action'],
        :store_in_group => cachepolicy['storeingroup'],
        :inval_groups   => cachepolicy['invalgroups'],
        :inval_objects  => cachepolicy['invalobjects'],
        :undef_action   => cachepolicy['undefaction'],
        :new_name       => cachepolicy['newname'],
      })
    end

    instances
  end

  mk_resource_methods

  # Map for conversion in the message.
  def property_to_rest_mapping
    {
      :name           => :policyname,
      :expression     => :rule,
      :store_in_group => :storeingroup,
      :inval_groups   => :invalgroups,
      :inval_objects  => :invalobjects,
      :undef_action   => :undefaction,
      :new_name       => :newname,
    }
  end

  def immutable_properties
    []
  end

  def per_provider_munge(message)
    message
  end
end
