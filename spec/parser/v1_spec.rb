require 'spec_helper'

describe OpenVPNStatusWeb::Parser::V1 do
  def status
    status_v1
  end

  context 'for client list' do
    it 'parses common names' do
      expect(status.client_list.map { |client| client[0] }).to eq(%w[foo bar])
    end

    it 'parses real addresses' do
      expect(status.client_list.map { |client| client[1] }).to eq(['1.2.3.4:1234', '1.2.3.5:1235'])
    end

    it 'parses received bytes' do
      expect(status.client_list.map { |client| client[2] }).to eq([11_811_160_064, 512])
    end

    it 'parses sent bytes' do
      expect(status.client_list.map { |client| client[3] }).to eq([4_194_304, 2048])
    end

    it 'parses connected since date' do
      expect(status.client_list.map { |client| client[4] }).to eq(
        [
          DateTime.new(2012, 1, 1, 23, 42, 0), DateTime.new(2012, 1, 1, 23, 42, 0)
        ]
      )
    end
  end

  context 'for routing table' do
    it 'parses virtual addresses' do
      expect(status.routing_table.map { |route| route[0] }).to eq(['192.168.0.0/24', '192.168.66.2', '192.168.66.3', '2001:db8:0:0::1000'])
    end

    it 'parses common names' do
      expect(status.routing_table.map { |route| route[1] }).to eq(%w[foo bar foo bar])
    end

    it 'parses real addresses' do
      expect(status.routing_table.map { |route| route[2] }).to eq(['1.2.3.4:1234', '1.2.3.5:1235', '1.2.3.4:1234', '1.2.3.5:1235'])
    end

    it 'parses last ref date' do
      expect(status.routing_table.map { |route| route[3] }).to eq(
        [
          DateTime.new(2012, 1, 1, 23, 42, 0), DateTime.new(2012, 1, 1, 23, 42, 0),
          DateTime.new(2012, 1, 1, 23, 42, 0), DateTime.new(2012, 1, 1, 23, 42, 0)
        ]
      )
    end
  end

  it 'parses global stats' do
    expect(status.global_stats.size).to eq(1)
    expect(status.global_stats.first).to eq(['Max bcast/mcast queue length', 42])
  end
end
