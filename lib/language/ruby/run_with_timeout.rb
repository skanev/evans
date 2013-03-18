require 'timeout'

RSpec.configure do |config|
  config.around(:each) do |example|
    Timeout::timeout(1, TimeoutError) { example.run }
  end
end
