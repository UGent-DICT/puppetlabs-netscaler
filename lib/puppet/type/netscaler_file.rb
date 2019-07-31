require_relative('../../puppet/parameter/netscaler_name')
require_relative('../../puppet/property/netscaler_traffic_domain')
require_relative('../../puppet/property/netscaler_truthy')

Puppet::Type.newtype(:netscaler_file) do
  @doc = 'Allows the uploading of a file to the Netscaler. only accepts names of *.cert *.key and *.txt. Currently this file is uploaded to /nsconfig/'

  apply_to_device
  ensurable

  newparam(:name, :parent => Puppet::Parameter::NetscalerName, :namevar => true)
  #XXX Validate with the below
  #ensure: change from absent to present failed: Could not set 'present' on ensure: REST failure: HTTP status code 400 detected.  Body of failure is: { "errorcode": 1075, "message": "Invalid name; names must begin with an alphanumeric character or underscore and must contain only alphanumerics, '_', '#', '.', ' ', ':', '@', '=' or '-' [name, hunner's website]", "severity": "ERROR" } at 55:/etc/puppetlabs/puppet/environments/produc

  newproperty(:content) do
    desc "File content, this will be encoded to Base64"
  end

  newparam(:encoding) do
    desc "Encoding type of the file content. Only accepts BASE64"
  end
end
