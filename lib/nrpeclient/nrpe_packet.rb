require 'zlib'

module Nrpeclient
  class NrpePacket
    NRPE_PACKET_VERSION_3 = 3
    NRPE_PACKET_VERSION_2 = 2
    NRPE_PACKET_VERSION_1 = 1

    QUERY_PACKET = 1
    RESPONSE_PACKET = 2

    MAX_PACKETBUFFER_LENGTH = 1024

    MAX_PACKET_SIZE = 12 + 1024

    attr_accessor :packet_version, :crc32, :result_code, :buffer, :perfdata

    def initialize(unpacked=nil)
      @packet_version = NRPE_PACKET_VERSION_2
      @random = 1

      if unpacked
        @packet_version = unpacked[0]
        @packet_type    = unpacked[1]
        @crc32          = unpacked[2]
        @result_code    = unpacked[3]
        @buffer         = unpacked[4]
        @random         = unpacked[5]
        # Parse perfdata and return as a hash
        if @buffer.include? "|" then
          @perfdata = Hash.new
          @buffer.split("|")[1].split(",").each do |metric|
            key = metric.split("=")[0].strip
            value = metric.split("=")[1].strip
            @perfdata[:"#{key}"] = value
          end
        end
      end
    end

    def packet_type
      case @packet_type
      when QUERY_PACKET    then :query
      when RESPONSE_PACKET then :response
      end
    end

    def packet_type=(type)
      case type
      when :query    then @packet_type = QUERY_PACKET
      when :response then @packet_type = RESPONSE_PACKET
      else
        raise "Invalid packet type"
      end
    end

    def calculate_crc32
      Zlib::crc32(self.to_bytes(0))
    end

    def validate_crc32
      raise 'Invalid CRC32' unless @crc32 == self.calculate_crc32
    end

    def strip_buffer
      self.buffer = self.buffer.lstrip.rstrip
    end

    def to_bytes(use_crc32=self.calculate_crc32)
      [ @packet_version, @packet_type, use_crc32, @result_code, @buffer, @random].pack("nnNna#{MAX_PACKETBUFFER_LENGTH}n")
    end

    def self.read(io, validate_crc32=true)
      bytes = io.read(MAX_PACKET_SIZE)
      values = bytes.unpack("nnNnA#{MAX_PACKETBUFFER_LENGTH}n")
      packet = self.new(values)
      packet.validate_crc32 if validate_crc32
      packet
    end
  end
end
