require 'spec_helper'

describe OpenVPNStatusWeb::Parser::ModernStateless do
  {
    2 => status_v2,
    3 => status_v3
  }.each do |version, status|
    context "for status-version #{version}" do
      it 'parses client list' do
        status.client_list.map { |client| client[0] }.should be_eql ["foo", "bar"]
      end

      it 'parses routing table' do
        status.routing_table.map { |route| route[1] }.should be_eql ["foo", "bar", "foo", "bar"]
      end

      it 'parses global stats' do
        status.global_stats.size.should be_eql 1
        status.global_stats.first.should be_eql ["Max bcast/mcast queue length", "42"]
      end
    end
  end
end
