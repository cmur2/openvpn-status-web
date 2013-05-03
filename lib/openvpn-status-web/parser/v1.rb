
module OpenVPNStatusWeb
  module Parser
    class V1
      def parse_status_log(text)
        current_section = :none
        client_list = []
        routing_table = []
        global_stats = []

        text.lines.each do |line|
          (current_section = :cl; next) if line == "OpenVPN CLIENT LIST\n"
          (current_section = :rt; next) if line == "ROUTING TABLE\n"
          (current_section = :gs; next) if line == "GLOBAL STATS\n"
          (current_section = :end; next) if line == "END\n"
      
          case current_section
          when :cl
            client_list << line.strip.split(',')
          when :rt
            routing_table << line.strip.split(',')
          when :gs
            global_stats << line.strip.split(',')
          end
        end

        status = Status.new
        status.client_list = client_list[2..-1].map { |client| parse_client(client) }
        status.routing_table = routing_table[1..-1].map { |route| parse_route(route) }
        status.global_stats = global_stats.map { |global| parse_global(global) }
        status
      end

      private

      def parse_client(client)
        client[2] = client[2].to_i
        client[3] = client[3].to_i
        client[4] = DateTime.strptime(client[4], '%a %b %d %k:%M:%S %Y')
        client
      end

      def parse_route(route)
        route[3] = DateTime.strptime(route[3], '%a %b %d %k:%M:%S %Y')
        route
      end

      def parse_global(global)
        global[1] = global[1].to_i
        global
      end
    end
  end
end
