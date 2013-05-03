
module OpenVPNStatusWeb
  module Parser
    class ModernStateless
      def self.parse_status_log(text, sep)
        status = Status.new
        status.client_list = []
        status.routing_table = []
        status.global_stats = []

        text.lines.each do |line|
          parts = line.strip.split(sep)
          status.client_list << parts[1..5] if parts[0] == "CLIENT_LIST"
          status.routing_table << parts[1..4] if parts[0] == "ROUTING_TABLE"
          status.global_stats << parts[1..2] if parts[0] == "GLOBAL_STATS"
        end

        status
      end
    end
  end
end
