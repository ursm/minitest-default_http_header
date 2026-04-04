require 'minitest/autorun'
require 'minitest/default_http_header'

class FakeBase
  Minitest::DefaultHttpHeader::HTTP_METHODS.each do |m|
    define_method(m) do |path, *args, **kwargs|
      @last_path   = path
      @last_args   = args
      @last_kwargs = kwargs
    end
  end
end

class FakeIntegration < FakeBase
  include Minitest::DefaultHttpHeader

  attr_reader :last_path, :last_args, :last_kwargs
end

class DefaultHttpHeaderTest < Minitest::Test
  def setup
    @subject = FakeIntegration.new
  end

  def test_request_without_default_headers
    @subject.get '/path'

    assert_equal({headers: {}}, @subject.last_kwargs)
  end

  def test_default_headers_are_sent
    @subject.default_headers['Authorization'] = 'Bearer token'
    @subject.get '/path'

    assert_equal({headers: {'Authorization' => 'Bearer token'}}, @subject.last_kwargs)
  end

  def test_per_request_headers_are_merged_with_default_headers
    @subject.default_headers['Authorization'] = 'Bearer token'
    @subject.get '/path', headers: {'Accept' => 'application/json'}

    assert_equal(
      {headers: {'Authorization' => 'Bearer token', 'Accept' => 'application/json'}},
      @subject.last_kwargs
    )
  end

  def test_per_request_headers_override_default_headers
    @subject.default_headers['Authorization'] = 'Bearer default'
    @subject.get '/path', headers: {'Authorization' => 'Bearer override'}

    assert_equal(
      {headers: {'Authorization' => 'Bearer override'}},
      @subject.last_kwargs
    )
  end

  def test_all_http_methods_use_default_headers
    @subject.default_headers['Authorization'] = 'Bearer token'

    %w(get post put patch delete).each do |m|
      @subject.send(m, '/path')

      assert_equal(
        {headers: {'Authorization' => 'Bearer token'}},
        @subject.last_kwargs,
        "#{m} should include default headers"
      )
    end
  end

  def test_default_headers_can_be_cleared
    @subject.default_headers['Authorization'] = 'Bearer token'
    @subject.default_headers.clear
    @subject.get '/path'

    assert_equal({headers: {}}, @subject.last_kwargs)
  end
end
