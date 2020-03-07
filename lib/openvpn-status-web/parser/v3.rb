# frozen_string_literal: true

require_relative 'modern_stateless'

module OpenVPNStatusWeb
  module Parser
    class V3
      def parse_status_log(text)
        OpenVPNStatusWeb::Parser::ModernStateless.parse_status_log(text, "\t")
      end
    end
  end
end
