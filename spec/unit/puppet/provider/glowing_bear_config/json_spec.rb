require 'spec_helper'

json_provider = Puppet::Type.type(:glowing_bear_config).provider(:json)

RSpec.describe json_provider do

  describe 'json provider' do

    let(:resource) do
      Puppet::Type.type(:glowing_bear_config).new(
          path: '/tmp/example.json',
          default_path: '/tmp/example.default.json',
          custom_properties: {'version' => '0.0.1'},
          )
    end

    let(:provider) do
      json_provider.new(resource)
    end

    it '#create' do
      Dir.mktmpdir do |dir|
        resource[:default_path] = File.join(dir, 'example.default.json')
        File.write(resource[:default_path], JSON.pretty_generate({
            property: 'default value',
            version: '0.0.1-SNAPSHOT'
                                                                }))
        resource[:path] = File.join(dir, 'example.json')
        provider.create
        expected_properties = {
            'property' => 'default value',
            'version' => '0.0.1'
        }
        written_properties = JSON.load(File.read(resource[:path]))
        expect(written_properties).to eq expected_properties
        expect(File.exist?(resource[:path])).to eq true
        expect(provider.file_missing(resource[:path])).to eq false
        expect(provider.exists?).to eq true
      end
    end

  end

end
