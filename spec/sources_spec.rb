# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require_relative 'spec_helper'

if property['apt_manage_sources_list'] == true &&
   property.key?('apt_sources_list') == true &&
   property['apt_sources_list'].nil? == false
  RSpec.describe ENV['KITCHEN_INSTANCE'] || host_inventory['hostname'] do
    context 'APT:SOURCE LIST' do
      describe 'The apt source list - /etc/apt/sources.list' do
        subject { file('/etc/apt/sources.list') }
        it { is_expected.to exist }
        it { is_expected.to be_owned_by 'root' }
        it { is_expected.to be_grouped_into 'root' }
        it { is_expected.to be_mode 644 }
        property['apt_sources_list'].each do |entry|
          its(:content) { is_expected.to match(Regexp.escape(entry)) }
        end
      end
    end
  end
end
