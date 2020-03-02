
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
          status.client_list << parse_client(parts[1..5]) if parts[0] == 'CLIENT_LIST'
          status.routing_table << parse_route(parts[1..4]) if parts[0] == 'ROUTING_TABLE'
          status.global_stats << parse_global(parts[1..2]) if parts[0] == 'GLOBAL_STATS'
        end

        status
      end

      private_class_method def self.parse_client(client)
        client[2] = client[2].to_i
        client[3] = client[3].to_i
        client[4] = DateTime.strptime(client[4], '%a %b %d %k:%M:%S %Y')
        client
      end

      private_class_method def self.parse_route(route)
        route[3] = DateTime.strptime(route[3], '%a %b %d %k:%M:%S %Y')
        route
      end

      private_class_method def self.parse_global(global)
        global[1] = global[1].to_i
        global
      end
    end
  end
end
