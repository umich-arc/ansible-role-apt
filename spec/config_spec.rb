# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require_relative 'spec_helper'

if property['apt_manage_config'] == true && property.key?('apt_config')
  RSpec.describe ENV['KITCHEN_INSTANCE'] || host_inventory['hostname'] do
    describe 'APT:CONFIG' do
      property['apt_config'].each do |file, config|
        describe file("/etc/apt/apt.conf.d/#{file}") do
          it { is_expected.to be_owned_by 'root' }
          it { is_expected.to be_grouped_into 'root' }
          it { is_expected.to be_mode 644 }
          config.each do |param, values|
            context "Option #{param}" do
              values.each do |value|
                let(:escaped_value) { Regexp.new(Regexp.escape(value.to_s), Regexp::IGNORECASE) }
                its(:content) { is_expected.to contain(escaped_value).from(param).to(/};/) }
              end
            end
          end
        end
      end
    end
  end
end
