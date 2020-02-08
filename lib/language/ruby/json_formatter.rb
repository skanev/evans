require 'rspec/core/formatters/base_text_formatter'
require 'json'

class JsonFormatter
  RSpec::Core::Formatters.register self,
    :start, :example_passed, :example_failed, :dump_summary

  def initialize(output)
    @output = output
    @store = {}
  end

  def start(notification)
    @store['count']  = notification.count
    @store['passed'] = []
    @store['failed'] = []
  end

  def example_passed(notification)
    example = notification.example
    @store['passed'] << example.full_description
  end

  def example_failed(notification)
    example = notification.example
    @store['failed'] << example.full_description
  end

  def dump_summary(_summary)
    @output.puts @store.to_json
  end
end
