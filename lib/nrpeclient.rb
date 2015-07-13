require "nrpeclient/version"


module Nrpeclient
  STATUS_OK = 0
  STATUS_WARNING = 1
  STATUS_CRITICAL = 2
end

require 'nrpeclient/check_nrpe'
require 'nrpeclient/nrpe_packet'
