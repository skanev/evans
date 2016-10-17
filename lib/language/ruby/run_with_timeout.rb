require 'timeout'

RSpec.configure do |config|
  config.around(:each) do |example|
    timeout = example.metadata[:timeout] || 1

    Timeout::timeout(timeout, Timeout::Error) { example.run }
  end
end
