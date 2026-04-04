# Minitest::DefaultHttpHeader

Set default HTTP headers in Rails integration tests.

Minitest version of [rspec-default_http_header](https://github.com/kenchan/rspec-default_http_header).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'minitest-default_http_header'
```

## Usage

Use `default_headers` to set HTTP headers that are automatically included in every request:

```ruby
class UsersApiTest < ActionDispatch::IntegrationTest
  setup do
    user = create(:user)
    default_headers['Authorization'] = user.token
  end

  test 'index' do
    get '/api/users.json'
    # Authorization header is sent automatically

    assert_response :success
  end
end
```

Per-request headers are merged with default headers:

```ruby
class UsersApiTest < ActionDispatch::IntegrationTest
  setup do
    default_headers['Authorization'] = 'your-authorization-token'
  end

  test 'index as JSON' do
    get '/api/users', headers: {'Accept' => 'application/json'}
    # Both Authorization and Accept headers are sent

    assert_response :success
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
