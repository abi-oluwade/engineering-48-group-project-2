# InSpec test for recipe elk_stack::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe service 'elasticsearch' do
  it { should be_running }
  it { should be_enabled }
end

describe service 'logstash' do
  it { should be_running }
  it { should be_enabled }
end

# describe service 'kibana' do
#   it { should be_running }
#   it { should be_enabled }
# end

describe port(9200), : do
  it { should be_listening }
end
