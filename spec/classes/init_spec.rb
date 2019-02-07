require 'spec_helper'
describe 'glowing_bear' do
  on_supported_os.each do |os, facts|
    context "with no transmart url specified on #{os}" do
      let(:facts) { facts }
      let(:node) { 'test2.example.com' }
      it { should compile.and_raise_error(/did not find a value for the name 'glowing_bear::transmart_url'/) }
    end

    context "with no gb backend url specified on #{os}" do
      let(:facts) { facts }
      let(:node) { 'nogbeurl.example.com' }
      it { should compile.and_raise_error(/did not find a value for the name 'glowing_bear::gb_backend_url'/) }
    end

    context "with url set on #{os}" do
      let(:facts) { facts }
      let(:node) { 'test.example.com' }
      it { is_expected.to create_class('glowing_bear') }
    end
  end
end
