require "pingfacts/version"
require "ipaddr"
require "resolv"
require "net/ping"

module Pingfacts
  class Error < StandardError; end

  class PingerResult
    attr_accessor :ip, :dnsname, :mac
  end

  def self.scan(network, method=Net::Ping::External)
    ip_range = IPAddr.new(network).to_range

    pingers = []
    onlines = []

    ip_range.each do |ip|
      pingers << Thread.new do
        pinger = Net::Ping::External.new(ip.to_s)
        if pinger.ping?
          onlines << ip.to_s
        end
      end
    end

    pingers.each do |t|
      t.join
    end

    mac_addresses = {}
    begin
      `ip neigh`.lines.each do |line|
        r = line.split(/\s+/)
        if r[3] == "lladdr"
          mac_addresses[r[0].strip] = r[4].strip
        end
      end
    rescue
      nil
    end

    result = []

    onlines.each do |ip|
      ipresult = PingerResult.new
      ipresult.ip = ip
      if mac_addresses.key?(ip)
        ipresult.mac = mac_addresses[ip]
      end
      begin
        ipresult.dnsname = Resolv.getname(ip)
      rescue
        nil
      end

      result << ipresult
    end

    result
  end
end
