require_relative('../../puppet/parameter/netscaler_name')
require_relative('../../puppet/property/netscaler_truthy')
require_relative('../../puppet/property/netscaler_traffic_domain')

Puppet::Type.newtype(:netscaler_policyhttpcallout) do
  @doc = 'Configuration for HTTP callout resource.'

  apply_to_device
  ensurable

  newparam(:name, parent: Puppet::Parameter::NetscalerName, namevar: true)

  newproperty(:ip_address) do
    desc 'IP Address of the server (callout agent) to which the callout is sent. Mutually exclusive with the Virtual Server parameter.'

    validate do |value|
      unless value.match(Resolv::IPv4::Regex) || value.match(Resolv::IPv6::Regex)
        raise ArgumentError, 'ip_address should be a valid IPv4 or IPv6 address.'
      end
    end
  end

  newproperty(:port) do
    desc 'Server port to which the HTTP callout agent is mapped. Mutually exclusive with the Virtual Server parameter.'

    validate do |value|
      if !value.is_a?(Integer) && Integer(value).between?(1, 65_535)
        raise ArgumentError, 'port should be a valid port number'
      end
    end

    munge do |value|
      Integer(value)
    end
  end

  newproperty(:vserver) do
    desc 'Name of the load balancing, content switching, or cache redirection virtual server (the callout agent) to which the HTTP callout is sent. Mutually exclusive with the IP address and port parameters.'
  end

  newproperty(:return_type) do
    desc 'Type of data that the target callout agent returns in response to the callout.'

    validate do |value|
      if [:TEXT, :NUM, :BOOL].none? { |s| s.to_s.eql? value }
        raise ArgumentError, 'Returntype should be one of "TEXT", "NUM" or "BOOL"'
      end
    end

    munge(&:upcase)
  end

  newproperty(:http_method) do
    desc 'Method used in the HTTP request that this callout sends. Mutually exclusive with the full HTTP request expression parameter.'

    validate do |value|
      if [:GET, :POST].none? { |s| s.to_s.eql? value }
        raise ArgumentError, 'Http_method should be either "GET" or "POST"'
      end
    end

    munge(&:upcase)
  end

  newproperty(:host_expression) do
    desc 'String expression to configure the Host header. Mutually exclusive with the full HTTP request expression parameter.'
  end

  newproperty(:url_stem_expression) do
    desc 'Default Syntax string expression for generating the URL stem. Mutually exclusive with the full HTTP request expression parameter.'
  end

  newproperty(:headers) do
    desc 'One or more headers to insert into the HTTP request. Each header is specified as "name(expr)", where expr is a default syntax expression that is evaluated at runtime to provide the value for the named header. You can configure a maximum of eight headers for an HTTP callout. Mutually exclusive with the full HTTP request expression.'

    munge do |value|
      [value] unless value.is_a?(Array)
    end
  end

  newproperty(:parameters) do
    desc 'One or more query parameters to insert into the HTTP request URL (for a GET request) or into the request body (for a POST request). Each parameter is specified as "name(expr)", where expr is an default syntax expression that is evaluated at run time to provide the value for the named parameter (name=value). The parameter values are URL encoded. Mutually exclusive with the full HTTP request expression.'

    munge do |value|
      [value] unless value.is_a?(Array)
    end
  end

  newproperty(:body_expression) do
    desc 'An advanced string expression for generating the body of the request. Mutually exclusive with the full HTTP request expression.'
  end

  newproperty(:full_request_expression) do
    desc 'Exact HTTP request, in the form of a default syntax expression, which the NetScaler appliance sends to the callout agent. If you set this parameter, you must not include HTTP method, host expression, URL stem expression, headers, or parameters.'
  end

  newproperty(:scheme) do
    desc 'Type of scheme for the callout server.'

    validate do |value|
      if [:http, :https].none? { |s| s.to_s.eql? value }
        raise ArgumentError, 'Scheme should be either "http" or "https"'
      end
    end

    munge(&:downcase)
  end

  newproperty(:result_expression) do
    desc 'Expression that extracts the callout results from the response sent by the HTTP callout agent. Must be a response based expression, that is, it must begin with HTTP.RES. The operations in this expression must match the return type.'
  end

  newproperty(:cache_time) do
    desc 'Duration, in seconds, for which the callout response is cached.'

    validate do |value|
      if !value.is_a?(Integer) && Integer(value).between?(1, 31_536_000)
        raise ArgumentError, 'Cache time should be an integer between 1 and 31536000.'
      end
    end

    munge do |value|
      Integer(value)
    end
  end

  newproperty(:comment) do
    desc 'Any comments to preserve information about this HTTP callout.'
  end

  validate do
    if (self[:ip_address] || self[:port]) && self[:vserver]
      raise ArgumentError, '"ip_address" and/or "port" cannot be set when "vserver" is defined.'
    end

    if (self[:http_method] || self[:host_expression] || self[:url_stem_expression] || self[:headers] || self[:parameters] || self[:body_expression]) && self[:full_request_expression]
      raise ArgumentError, '"full_request_expression" cannot be set when one of "http_method", "host_expression", "url_stem_expression", "headers", "parameters" and/or "body_expression" is given.'
    end
  end
end
