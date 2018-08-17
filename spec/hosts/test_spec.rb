require 'spec_helper'

describe 'test.example.com' do
  on_supported_os.each do |os, facts|
    context "glowing_bear with database credentials set on #{os}" do
      let(:facts) { facts }
      it { is_expected.to create_class('glowing_bear') }
    end
  end
end
