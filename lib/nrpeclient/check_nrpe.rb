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
        @ssl_context = OpenSSL::SSL::SSLContext.new :SSLv23
        @ssl_context.ciphers = 'ADH'
        @ssl_context.cert = OpenSSL::X509::Certificate.new(File.open(@options.fetch(:ssl_cert)))
        @ssl_context.key = OpenSSL::PKey::RSA.new(File.open(@options.fetch(:ssl_key)))
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
          socket = OpenSSL::SSL::SSLSocket.new(socket, @ssl_context)
          socket.sync_close = true
          socket.connect
        end

        socket.write(query.to_bytes)
        response = Nrpeclient::NrpePacket.read(socket, !@options[:ssl])
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
      return self.send(message)
    end
  end
end
