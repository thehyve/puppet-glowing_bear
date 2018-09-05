require 'spec_helper'
require 'puppet'

describe Puppet::Type.type(:glowing_bear_config) do

  let(:resource) do
    Puppet::Type.type(:glowing_bear_config).new(
        path: '/tmp/example.json',
        default_path: '/tmp/example.default.json',
        custom_properties: {version: '0.0.1'},
    )
  end

  context 'resource defaults' do
    it { expect(resource[:path]).to eq '/tmp/example.json' }
    it { expect(resource[:name]).to eq '/tmp/example.json' }
    it { expect(resource[:default_path]).to eq '/tmp/example.default.json' }
    it { expect(resource[:custom_properties][:version]).to eq '0.0.1' }
  end

  it 'verify resource[:path] is absolute filepath' do
    expect do
      resource[:path] = 'relative/file'
    end.to raise_error(Puppet::Error, %r{glowing bear config path must be absolute: })
  end

  it 'verify resource[:default_path] is absolute filepath' do
    expect do
      resource[:default_path] = 'relative/file'
    end.to raise_error(Puppet::Error, %r{glowing bear default config path must be absolute: })
  end

end
