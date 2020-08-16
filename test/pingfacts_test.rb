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
end
