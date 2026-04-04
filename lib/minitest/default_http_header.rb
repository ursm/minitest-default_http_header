require 'minitest/default_http_header/version'
require 'active_support/concern'
require 'active_support/lazy_load_hooks'

module Minitest
  module DefaultHttpHeader
    extend ActiveSupport::Concern

    HTTP_METHODS = %w(get post put patch delete).freeze

    def default_headers
      @default_headers ||= {}
    end

    HTTP_METHODS.each do |m|
      define_method(m) do |path, *args, **kwargs|
        kwargs[:headers] = default_headers.merge(kwargs[:headers] || {})

        super(path, *args, **kwargs)
      end
    end
  end
end

ActiveSupport.on_load(:action_dispatch_integration_test) do
  include Minitest::DefaultHttpHeader
end
