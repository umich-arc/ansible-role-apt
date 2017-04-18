# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require_relative 'spec_helper'

if property['apt_manage_keys'] == true &&
   property.key?('apt_keys') == true &&
   property['apt_keys'].nil? == false
  RSpec.describe ENV['KITCHEN_INSTANCE'] || host_inventory['hostname'] do
    context 'APT:KEYS' do
      property['apt_keys'].each do |key|
        next if !key.key?('id') || !key.key?('keyserver')
        describe "key #{key['id']}" do
          key_id = key['id'].match(/^(0x|)(\S+)$/).captures[1]
          subject { command("apt-key finger | grep 'Key fingerprint' | sed -e 's/Key fingerprint =//g' -e 's/ //g'") } # rubocop:disable Metrics/LineLength
          its(:stdout) { is_expected.to match(key_id) }
        end
      end
    end
  end
end
