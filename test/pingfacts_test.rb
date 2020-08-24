require "test_helper"

class PingfactsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Pingfacts::VERSION
  end

  def test_it_accepts_dns_names
    result = ::Pingfacts.scan("google.com")
    assert_equal result.length, 1
    assert_equal result.first.class, ::Pingfacts::PingerResult
  end

  def test_it_handles_array
    result = ::Pingfacts.scan(["8.8.8.8", "8.8.4.4"])
    assert_equal result.length, 2
    result.each do |r|
      assert_equal r.class, ::Pingfacts::PingerResult
    end
  end

  def test_better_compare_pingerresult
    a = ::Pingfacts::PingerResult.new
    a.ip = "192.168.178.1"
    a.dnsname = "Fritzbox"
    a.mac = "00:11:22:33:44:55"
    b = ::Pingfacts::PingerResult.new
    b.ip = "192.168.0.1"
    b.mac = a.mac
    c = ::Pingfacts::PingerResult.new
    c.ip = "10.0.0.1"
    c.dnsname = a.dnsname
    d = ::Pingfacts::PingerResult.new
    d.ip = a.ip
    d.mac = a.mac
    d.dnsname = a.dnsname

    assert_equal ([a] - [b]).length, 0
    assert_equal ([a] - [c]).length, 0
    assert_equal ([a] - [d]).length, 0
    assert_equal ([b] - [c]).length, 1

    a.class.strictmode = true
    assert_equal ([a] - [b]).length, 1
    assert_equal ([a] - [c]).length, 1
    assert_equal ([b] - [c]).length, 1
    assert_equal ([a] - [d]).length, 0
  end

  def test_get_vendor
    empty = ::Pingfacts::PingerResult.new
    assert_nil empty.vendor

    motorola = ::Pingfacts::PingerResult.new
    motorola.ip = "192.168.178.11"
    motorola.dnsname = "moto.fritz.box"
    motorola.mac = "24:46:c8:00:00:00"
    assert (/motorola/i).match(motorola.vendor)

    huawei = ::Pingfacts::PingerResult.new
    huawei.ip = "192.168.178.12"
    huawei.dnsname = "hua.fritz.box"
    huawei.mac = "44:d7:91:00:00:00"
    assert (/huawei/i).match(huawei.vendor)

    fritzbox = ::Pingfacts::PingerResult.new
    fritzbox.ip = "192.168.178.1"
    fritzbox.dnsname = "fritz.box"
    fritzbox.mac = "98:9b:CB:00:00:00"
    assert (/avm/i).match(fritzbox.vendor)
  end
end
