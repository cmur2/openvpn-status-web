# frozen_string_literal: true

module OpenVPNStatusWeb
  module Parser
    class ModernStateless
      def self.parse_status_log(text, sep)
        status = Status.new
        status.client_list_headers = []
        status.client_list = []
        status.routing_table_headers = []
        status.routing_table = []
        status.global_stats = []

        text.lines.each do |line|
          parts = line.strip.split(sep)
          status.client_list_headers = parts[2..-1] if parts[0] == 'HEADER' && parts[1] == 'CLIENT_LIST'
          status.client_list << parse_client(parts[1..-1], status.client_list_headers) if parts[0] == 'CLIENT_LIST'
          status.routing_table_headers = parts[2..-1] if parts[0] == 'HEADER' && parts[1] == 'ROUTING_TABLE'
          status.routing_table << parse_route(parts[1..-1], status.routing_table_headers) if parts[0] == 'ROUTING_TABLE'
          status.global_stats << parse_global(parts[1..2]) if parts[0] == 'GLOBAL_STATS'
        end

        status
      end

      private_class_method def self.parse_client(client, headers)
        headers.each_with_index do |header, i|
          client[i] = parse_date(client[i]) if header.end_with?('Since')
          client[i] = client[i].to_i if header.start_with?('Bytes')
        end

        client
      end

      private_class_method def self.parse_route(route, headers)
        headers.each_with_index do |header, i|
          route[i] = parse_date(route[i]) if header.end_with?('Last Ref')
        end

        route
      end

      private_class_method def self.parse_global(global)
        global[1] = global[1].to_i
        global
      end

      private_class_method def self.parse_date(date_string)
        DateTime.strptime(date_string, '%a %b %d %k:%M:%S %Y')
      rescue ArgumentError
        DateTime.strptime(date_string, '%Y-%m-%d %k:%M:%S')
      end
    end
  end
end
