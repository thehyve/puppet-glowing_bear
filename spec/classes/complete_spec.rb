require 'spec_helper'
describe 'glowing_bear::complete' do
  context 'with default values for all parameters' do
    let(:node) { 'test2.example.com' }
    it { should compile.and_raise_error(/parameter 'transmart_url' expects a String value, got Undef/) }
  end
  context 'with url set' do
    let(:node) { 'test.example.com' }
    it { is_expected.to create_class('glowing_bear::assets') }
    it { is_expected.to create_class('glowing_bear::config') }
    it { is_expected.to create_class('glowing_bear::vhost') }
  end
end
