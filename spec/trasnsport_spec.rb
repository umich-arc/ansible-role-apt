# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require_relative 'spec_helper'

if property['apt_manage_transports'] == true
  RSpec.describe ENV['KITCHEN_INSTANCE'] || host_inventory['hostname'] do
    describe 'APT:TRANSPORTS' do
      property['apt_transports'].each do |transport|
        describe package("apt-transport-#{transport}") do
          it { is_expected.to be_installed }
          if property.key?("apt_transport_#{transport}_version")
            context 'should match version' do
              let(:pkg_version) { property["apt_transport_#{transport}_version"] }
              subject { command("dpkg-query -W apt-transport-#{transport}") }
              its(:stdout) { is_expected.to match(/#{pkg_version}/) }
            end
          end
        end
      end
    end
  end
end
