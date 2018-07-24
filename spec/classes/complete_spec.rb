require 'spec_helper'
describe 'glowing_bear::complete' do
  on_supported_os.each do |os, facts|
    context "with default values for all parameters on #{os}" do
      let(:facts) { facts }
      let(:node) { 'test2.example.com' }
      it { should compile.and_raise_error(/did not find a value for the name 'glowing_bear::transmart_url'/) }
    end
    context "with url set on #{os}" do
      let(:facts) { facts }
      let(:node) { 'test.example.com' }
      it { is_expected.to create_class('glowing_bear::assets') }
      it { is_expected.to create_class('glowing_bear::config') }
      it { is_expected.to create_class('glowing_bear::vhost') }
    end
    context "with OpenID Connect (OIDC) configured without server url on #{os}" do
      let(:facts) { facts }
      let(:node) { 'test3.example.com' }
      it { should compile.and_raise_error(/No OpenID Connect server configured/) }
    end
    context "with OpenID Connect (OIDC) configured correctly on #{os}" do
      let(:facts) { facts }
      let(:node) { 'test4.example.com' }
      it { is_expected.to create_class('glowing_bear::assets') }
      it { is_expected.to create_class('glowing_bear::config') }
      it { is_expected.to create_class('glowing_bear::vhost') }
    end
  end
end
