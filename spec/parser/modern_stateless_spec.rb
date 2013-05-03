require 'spec_helper'

describe OpenVPNStatusWeb::Parser::ModernStateless do
  {
    2 => status_v2,
    3 => status_v3
  }.each do |version, status|
    context "for status-version #{version}" do
      context 'for client list' do
        it 'parses common names' do
          status.client_list.map { |client| client[0] }.should be == ["foo", "bar"]
        end

        it 'parses real addresses' do
          status.client_list.map { |client| client[1] }.should be == ["1.2.3.4:1234", "1.2.3.5:1235"]
        end
        
        it 'parses received bytes' do
          status.client_list.map { |client| client[2] }.should be == [11811160064, 512]
        end

        it 'parses sent bytes' do
          status.client_list.map { |client| client[3] }.should be == [4194304, 2048]
        end

        it 'parses connected since date' do
          status.client_list.map { |client| client[4] }.should be == [DateTime.new(2012,1,1,23,42,0), DateTime.new(2012,1,1,23,42,0)]
        end
      end

      context 'for routing table' do
        it 'parses virtual addresses' do
          status.routing_table.map { |route| route[0] }.should be == ["192.168.0.0/24", "192.168.66.2", "192.168.66.3", "2001:db8:0:0::1000"]
        end

        it 'parses common names' do
          status.routing_table.map { |route| route[1] }.should be == ["foo", "bar", "foo", "bar"]
        end

        it 'parses real addresses' do
          status.routing_table.map { |route| route[2] }.should be == ["1.2.3.4:1234", "1.2.3.5:1235", "1.2.3.4:1234", "1.2.3.5:1235"]
        end

        it 'parses last ref date' do
          status.routing_table.map { |route| route[3] }.should be == [DateTime.new(2012,1,1,23,42,0), DateTime.new(2012,1,1,23,42,0), DateTime.new(2012,1,1,23,42,0), DateTime.new(2012,1,1,23,42,0)]
        end
      end

      it 'parses global stats' do
        status.global_stats.size.should be == 1
        status.global_stats.first.should be == ["Max bcast/mcast queue length", 42]
      end
    end
  end
end
