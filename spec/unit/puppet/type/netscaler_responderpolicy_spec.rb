require 'spec_helper'

res_type_name = :netscaler_responderpolicy
res_type = Puppet::Type.type(res_type_name)

describe res_type do
  # create setting name type target bypasssafetycheck comment
  let(:provider) do
    prov = stub 'provider'
    prov.stubs(:name).returns(res_type_name)
    prov
  end
  let(:res_type) do
    type = res_type
    type.stubs(:defaultprovider).returns provider
    type
  end
  let(:resource) do
    res_type.new(name: 'test_node')
  end

  it 'has :name be its namevar' do
    res_type.key_attributes.should == [:name]
  end

  # set responderpolicy to something else
  # remove a provideraction
end
