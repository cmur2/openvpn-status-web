
require 'openvpn-status-web/parser/modern_stateless'

module OpenVPNStatusWeb
  module Parser
    class V3
      def parse_status_log(text)
        OpenVPNStatusWeb::Parser::ModernStateless.parse_status_log(text, "\t")
      end
    end
  end
end
