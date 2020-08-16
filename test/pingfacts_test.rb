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
end
