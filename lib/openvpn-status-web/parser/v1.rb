
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
          when :cl then client_list << line.strip.split(',')
          when :rt then routing_table << line.strip.split(',')
          when :gs then global_stats << line.strip.split(',')
          end
        end

        status = Status.new
        status.client_list = client_list[2..-1]
        status.routing_table = routing_table[1..-1]
        status.global_stats = global_stats
        status
      end
    end
  end
end
