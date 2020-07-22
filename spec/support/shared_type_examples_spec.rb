shared_examples 'a puppet type' do |parameter_tests, res_type_name|
  res_type = Puppet::Type.type(res_type_name)

  let(:provider) do
    prov = stub 'provider'
    prov.stubs(:name).returns(res_type_name)
    prov
  end
  let(:type) do
    val = res_type
    val.stubs(:defaultprovider).returns provider
    val
  end
  let(:resource) do
    type.new(name: 'test')
  end

  parameter_tests.each do |param, tests|
    describe "parameter #{param}" do
      it 'exists' do
        expect { resource[param] }.not_to raise_error
      end

      if tests.key?(:default)
        it "should have a default of #{tests[:default]}" do
          resource[param].should == tests[:default]
        end
      else
        pending('should have a default')
      end

      if tests[:valid]
        tests[:valid].each do |test_value|
          it "should allow a valid value, for example: #{test_value}" do
            expect { resource[param] = test_value }.not_to raise_error(Puppet::Error)
            resource[param].should == test_value
          end
        end
      else
        pending('should accept valid values')
      end

      if tests[:invalid]
        tests[:invalid].each do |test_value|
          it "should throw an error for an invalid value, for example: #{test_value.inspect}" do
            expect { resource[param] = test_value }.to raise_error(Puppet::Error, %r{^Parameter #{param.to_s} failed:})
          end
        end
      else
        pending('should throw an error for invalid values')
      end

      if prop == res_type.propertybyname(param)
        it 'has docs' do
          prop.doc.should_not.nil?
          prop.doc.should_not == ''
        end
      end
    end
  end
end
