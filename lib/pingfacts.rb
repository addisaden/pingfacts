require "pingfacts/version"
require "ipaddr"
require "resolv"
require "net/ping"

module Pingfacts
  class Error < StandardError; end

  class PingerResult
    attr_accessor :ip, :dnsname, :mac
  end

  def self.scan(network_args, method=Net::Ping::External)
    network_list = []
    pingers = []
    onlines = []

    if network_args.class == Array
      network_list += network_args
    else
      network_list << network_args
    end

    network_list.each do |network|
      begin
        ip_range = IPAddr.new(network).to_range

        ip_range.each do |ip|
          pingers << Thread.new do
            pinger = Net::Ping::External.new(ip.to_s)
            if pinger.ping?
              onlines << ip.to_s
            end
          end
        end
      rescue IPAddr::InvalidAddressError
        pingers << Thread.new do
          pinger = Net::Ping::External.new(network)
          if pinger.ping?
            onlines << network
          end
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
      rescue Resolv::ResolvError
        ipresult.ip = Resolv.getaddress(ip)
        ipresult.dnsname = ip
      rescue
        nil
      end

      result << ipresult
    end

    result
  end
end
