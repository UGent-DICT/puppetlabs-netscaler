require 'faraday/parameters'

class Puppet::Util::NetworkDevice::Transport::DoNotEncoder
  include ::Faraday::NestedParamsEncoder
  def self.encode(params)
    if params && !params.empty?
      params.map { |k, v|
        "#{k}=#{v}"
      }.join '&'
    end
  end
end
