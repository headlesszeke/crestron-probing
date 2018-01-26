#!/usr/bin/env ruby
# coding: utf-8
require 'socket'
require 'timeout'

BROADCAST_ADDR = "255.255.255.255"
BIND_ADDR = "0.0.0.0"
PORT = 41794
IFACE = ARGV[0]
timeout = 5

# socket setup
socket = UDPSocket.new
socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BINDTODEVICE, IFACE) if IFACE
socket.bind(BIND_ADDR, PORT)

# magic probe
hostname = "blah" # any string will do
buffer = "\x14\x00\x00\x00\x01\x04\x00\x03\x00\x00" + hostname + "\x00" * (256 - hostname.length) # padded with null bytes up to 256

puts "sending discover request"
socket.send(buffer,0,BROADCAST_ADDR,PORT)

puts "waiting #{timeout} second#{"s" if timeout > 1} for responses..."
puts ""

while true
  begin
    Timeout::timeout(timeout) do
      resp, addr = socket.recvfrom(1024)
      if resp && !Socket.ip_address_list.map {|i| i.ip_address}.include?(addr.last) # make sure its not our own packet
        puts addr.last.center(21,"-")
        puts "Hostname: #{resp[10,256].gsub("\x00","")}"
        info = resp[266,128].gsub("\x00","")
        model = info.match(/^\S+/)
        if model
          puts "Model: #{model[0]}"
        end
        firmware = info.match(/\[v((?:\d+\.)*\d+)/)
        if firmware
          puts "Firmware: #{firmware[1]}"
        end
        build = info.match(/\((.+?)\)/)
        if build
          puts "Build date: #{build[1]}"
        end
      end
    end
  rescue Timeout::Error, Interrupt
    break
  end
end

# socket teardown
socket.close

puts "-" * 21
puts "done"

