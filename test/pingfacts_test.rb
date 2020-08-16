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
end
