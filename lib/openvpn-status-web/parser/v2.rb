
module OpenVPNStatusWeb
  module Parser
    class V2
      def parse_status_log(text)
        client_list = []
        routing_table = []
        global_stats = []

        text.lines.each do |line|
          parts = line.strip.split(',')
          client_list << parts[1..5] if parts[0] == "CLIENT_LIST"
          routing_table << parts[1..4] if parts[0] == "ROUTING_TABLE"
          global_stats << parts[1..2] if parts[0] == "GLOBAL_STATS"
        end

        status = Status.new
        status.client_list = client_list
        status.routing_table = routing_table
        status.global_stats = global_stats
        status
      end
    end
  end
end
