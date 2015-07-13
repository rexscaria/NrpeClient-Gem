require 'socket'
require 'openssl'

module Nrpeclient
  class CheckNrpe
    DEFAULT_OPTIONS = {
                        :host => '0.0.0.0',
                        :port => '5666',
                        :ssl => false
                      }


    def initialize(options={})
      @options = DEFAULT_OPTIONS.merge(options)
      if @options[:ssl]
        @ssl = {}
        @ssl.context = OpenSSL::SSL::SSLContext.new :SSLv23
        @ssl.context.ciphers = 'ADH'
        @ssl.context.cert = OpenSSL::X509::Certificate.new(File.open("certificate.crt"))
        @ssl.context.key = OpenSSL::PKey::RSA.new(File.open("certificate.key"))
        @ssl.context.version = :SSLv23
      end
    end

    def send(message)
      query = Nrpeclient::NrpePacket.new
      query.packet_type = :query
      query.buffer = message
      query.result_code = Nrpeclient::STATUS_UNKNOWN
      begin
        socket = TCPSocket.open(@options[:host], @options[:port])
        if @options[:ssl]
          socket = OpenSSL::SSL::SSLSocket.new(socket, @ssl.context)
          socket.sync_close = true
          socket.connect
        end

        socket.print(query.to_bytes)
        response = socket.read
        socket.close
        return response
      rescue Errno::ETIMEDOUT
        raise 'NRPE request timed out'
      end
    end

    def send_command(command, *args)
      message = command
      args.each do |arg|
        message += '!' + arg
      end
      result_bytes = self.send(message)
      response = Nrpeclient::NrpePacket.new
      response.packet_version = result_bytes[0,2]
      response.packet_type = :response
      response.crc32 = result_bytes[4,4]
      response.result_code = result_bytes[8,2]
      response.buffer = result_bytes[10,1024]
      # response.validate_crc32
      response.strip_buffer
      return response
    end
  end
end
