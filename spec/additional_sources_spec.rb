# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require_relative 'spec_helper'

if property['apt_manage_additional_sources'] == true &&
   property.key?('apt_additional_sources') == true &&
   property['apt_additional_sources'].nil? == false
  RSpec.describe ENV['KITCHEN_INSTANCE'] || host_inventory['hostname'] do
    context 'APT:ADDITIONAL SOURCES' do
      property['apt_additional_sources'].each do |src_list|
        describe "Source #{src_list['name']}" do
          subject { file("/etc/apt/sources.list.d/#{src_list['name']}.list") }
          it { is_expected.to exist }
          it { is_expected.to be_owned_by 'root' }
          it { is_expected.to be_grouped_into 'root' }
          it { is_expected.to be_mode 644 }
          src_list['entries'].each do |entry|
            its(:content) { is_expected.to match(Regexp.escape(entry)) }
          end
        end
      end
    end
  end
end
