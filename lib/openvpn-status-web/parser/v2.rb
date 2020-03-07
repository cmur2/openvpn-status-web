
require_relative 'modern_stateless'

module OpenVPNStatusWeb
  module Parser
    class V2
      def parse_status_log(text)
        OpenVPNStatusWeb::Parser::ModernStateless.parse_status_log(text, ',')
      end
    end
  end
end
