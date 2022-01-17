# frozen_string_literal: true

module OpenVPNStatusWeb
  class Status
    attr_accessor :client_list_headers
    attr_accessor :client_list
    attr_accessor :routing_table_headers
    attr_accessor :routing_table
    attr_accessor :global_stats
  end
end
